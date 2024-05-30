Title: Building fast Wikipedia bots in Rust
Date: 2022-01-21 08:00:00
Category: MediaWiki
Tags: rust, api, mediawiki, wikipedia, bots, mwbot

Lately I've been working on [mwbot-rs](https://www.mediawiki.org/wiki/Mwbot-rs), a framework to write bots and tools in Rust. My main focus is for things related to Wikipedia, but all the code is generic enough to be used by any
modern (1.35+) MediaWiki installation. One specific feature of mwbot-rs I want to highlight today is the way it enables building incredibly fast [Wikipedia bots](https://en.wikipedia.org/wiki/Wikipedia:Bots), taking advantage of
Rust's "[fearless concurrency](https://doc.rust-lang.org/book/ch16-00-concurrency.html)".

Most Wikipedia bots follow the same general process:

1. Fetch a list of pages
2. For each page, process the page metadata/contents, possibly fetching other pages for more information
3. Combine all the information together, into the new page contents and save the page, and possibly other pages.

The majority of bots have rather minimal/straightforward processing, so they are typically limited by the speed of I/O, since all fetching and edits happens over network requests to the API.

MediaWiki has a robust [homegrown API](https://www.mediawiki.org/wiki/API:Main_page) (known as the "Action API") that predates modern REST, GraphQL, etc. and generally allows fetching information based on how it's organized in the database. It is optimized for
bulk lookups, for example to get two pages' basic metadata (`prop=info`), you just set `&titles=Albert Einstein|Taylor Swift` ([example](https://en.wikipedia.org/w/api.php?action=query&titles=Albert%20Einstein|Taylor%20Swift&prop=info&formatversion=2)).

However, when using this API, the [guidelines](https://www.mediawiki.org/wiki/API:Etiquette) are to make requests in series, not parallel, or in other words, use a concurrency of 1. Not to worry, there's a newer
[Wikimedia REST API](https://en.wikipedia.org/api/rest_v1/) (aka "RESTBase") that allows for concurrency up to 200 req/s, which makes it a great fit for writing our fearlessly concurrent bots. As a bonus, the REST API provides page
content in [annotated HTML format](https://www.mediawiki.org/wiki/Specs/HTML), which means it can be interpreted using any HTML parser rather than needing a dedicated wikitext parser, but that's a topic for another blog post.

Let's look at an example of a rather simple Wikipedia bot that I recently ported from Python to concurrent Rust. The bot's task is to create redirects for [SCOTUS](https://en.wikipedia.org/wiki/Supreme_Court_of_the_United_States)
cases that don't have a period after "v" between parties. For example, it would create a redirect from `Marbury v Madison` to `Marbury v. Madison`. If someone leaves out the period while searching, they'll still end up at the correct
article instead of having to find it in the search results. You can see the full source code [on GitLab](https://gitlab.com/mwbot-rs/contrib/-/blob/ce4bbed79e2502de4f9268a5e48a322c6d822941/legoktm/scotus-redirects/src/main.rs). I
omitted a bit of code to focus on the concurrency aspects.

First, we get a list of all the pages in [Category:United States Supreme Court cases](https://en.wikipedia.org/wiki/Category:United_States_Supreme_Court_cases).

```rust
let mut gen = categorymembers_recursive(
    &bot,
    "Category:United States Supreme Court cases",
);
```

Under the hood, this uses an [API generator](https://www.mediawiki.org/wiki/API:Query#Generators), which allows us to get the same `prop=info` metadata in the same request we are fetching the list of pages. This metadata is stored in
the `Page` instance that's yielded by the page generator. Now calls to `page.is_redirect()` can be answered immediately without needing to make a one-off HTTP request (normally it would be lazy-loaded).

The next part is to spawn a Tokio task for each page.

```rust
let mut handles = vec![];
while let Some(page) = gen.recv().await {
    let page = page?;
    let bot = bot.clone();
    handles.push(tokio::spawn(
        async move { handle_page(&bot, page).await },
    ));
}
```

The `mwbot::Bot` type keeps all data wrapped in `Arc<T>`, which makes it cheap to clone since we're not actually cloning the underlying data. We keep track of each `JoinHandle` returned by `tokio::spawn()` so once each task is spawned,
we can `await` on each one so the program only exits once all threads have been processed. We can also access the return value of each task, which in this case is `Result<bool>`, where the boolean indicates whether the redirect was
created or not, allowing us to print a closing message saying how many new redirects were created.

Now let's look at what each task does. The next three code blocks make up our `handle_page` function.

```rust
// Should not create if it's a redirect
if page.is_redirect().await? {
    println!("{} is redirect", page.title());
    return Ok(false);
}
```

First we check that the page we just got is not a redirect itself, as we don't want to create a redirect to another redirect. As mentioned earlier, the `page.is_redirect()` call does not incur a HTTP request to the API since we
already preloaded that information.

```rust
let new = page.title().replace(" v. ", " v ");
let newpage = bot.page(&new)?;
// Create if it doesn't exist
let create = match newpage.html().await {
    Ok(_) => false,
    Err(Error::PageDoesNotExist(_)) => true,
    Err(err) => return Err(err.into()),
}
if !create {
    return Ok(false);
}
````

Now we create a new `Page` instance that has the same title, but with the period removed. We need to make sure this page doesn't exist before we try to create it. We could use the `newpage.exists()` function, except it will make a
HTTP request to the Action API since the page doesn't have that metadata preloaded. Even worse, the Action API limits us to a concurrency of 1, so any task that has made it this far now loses the concurrency benefit we were hoping for.

So, we'll just cheat a bit by making a request for the page's HTML, served by the REST API that allows for the 200 req/s concurrency. We throw away the actual HTML response, but it's not that wasteful given that in most cases we either
get a very small HTML response representing the redirect or we get a 404, indicating the page doesn't exist. [Issue #49](https://gitlab.com/mwbot-rs/mwbot/-/issues/49) proposes using a HEAD request to avoid that waste.

```rust
let target = page.title();
// Build the new HTML to be saved
let code = { ... };
println!("Redirecting [[{}]] to [[{}]]", &new, target);
newpage.save(code, ...).await?;
Ok(true)
```

Finally we build the HTML to be saved and then save the page. The `newpage.save()` function calls the API with `action=edit` to save the page, which limits us to a concurrency of 1. That's not actually a problem here, as by Wikipedia
policy, bots generally are supposed to pause 10 seconds in between edits if there is no urgency to the edits (in constrast to an anti-vandalism bot wants to bad revert edits as fast as possible). This is mostly to avoid cluttering up the
feed of recent changes that humans patrol. So regardless how fast we can process the few thousand SCOTUS cases, we still have to wait 10 seconds in between each edit we want to make.

Despite that forced delay, the concurrency will make most bots faster. If the few redirects we need to create appear at the end of our categorymembers queue, we'd first have to process all the pages that come before it just to save one
or two at the end. Now that everything is processed concurrently the edits will happen pretty quickly, despite being at the end of the queue.

The example we looked through was also quite simple, other bots can have `handle_page` functions that take longer than 10 seconds because of having to fetch multiple pages, in which case the concurrency really helps. My
[archiveindexer](https://gitlab.com/mwbot-rs/contrib/-/tree/3659da1c6a5476b01cb12d4a03ed649eceead3df/legoktm/archiveindexer) bot operates on a list of pages, for each page, it fetches all the talk page archives and builds an index of
the discussions on them, which can easily end up pulling 5 to 50 pages depending on how controversial the subject is. The original Python version of this code took about 3-4 hours, the new concurrent Rust version finishes in 20 minutes.

The significant flaw in this goal of concurrent bots is that the Action API limits us to a concurrency of 1 request at a time. The cheat we did earlier requires intimate knowledge of how each underlying function works with the APIs,
which is not a reasonable expectation, nor is it a good optimization strategy since it could change underneath you.

One of the strategies we are implementing to work around this is to combine compatible Action API requests. Since the
Action API does really well at providing bulk lookups, we can intercept multiple similar requests, for example `page.exists()`, merge all the parameters into one request, send it off and then split the response up back to each original
caller. This lets us process multiple threads' requests while still only sending one request to the server.

This idea of combining requests is [currently behind an unstable feature flag](https://gitlab.com/mwbot-rs/mwbot/-/issues/52) as some edge cases are still worked out. Credit for this idea goes to Lucas Werkmeister, who pioneered it in
his [m3api project](https://github.com/lucaswerkmeister/m3api#automatically-combining-requests).

If this works interests you, the mwbot-rs project is always looking for more contributors, please reach out, either on-wiki, on [GitLab](https://gitlab.com/mwbot-rs/mwbot), or in the `#wikimedia-rust:libera.chat` room (Matrix or IRC).
