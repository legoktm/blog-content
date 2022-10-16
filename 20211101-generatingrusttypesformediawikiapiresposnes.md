Title: Generating Rust types for MediaWiki API responses
Date: 2021-11-01 06:50:22
Category: MediaWiki
Tags: rust, mediawiki, api, mwapi_responses

I just released version 0.2.0 of the [mwapi_responses](https://lib.rs/crates/mwapi_responses) crate. It automatically generates Rust types based on the query parameters specified for use in MediaWiki API requests.
If you're not familiar with the MediaWiki API, I suggest you play around with the [API sandbox](https://en.wikipedia.org/wiki/Special:ApiSandbox). It is highly dynamic, with the user specifying query parameters and
values for each property they wanted returned.

For example, if you wanted a page's categories, you'd use `action=query&prop=categories&titles=[...]`. If you just wanted basic page metadata you'd use `prop=info`. For
information about revisions, like who made specific edits, you'd use `prop=revisions`. And so on, for all the different types of metadata. For each property module, you can further filter what properties you want. If
under info, you wanted the URL to the page, you'd use `inprop=url`. If you wanted to know the user who created the revision, you'd use `rvprop=user`. For the most part, each field in the response can be toggled on or off
using various prop parameters. These parameters can be combined, so you can just get the exact data that your use-case needs, nothing extra.

For duck-typed languages like Python, this is pretty convenient. You know what fields you've requested, so that's all you access. But in Rust, it means you either need to type out the entire response struct for each API
query you make, or just rely on the dynamic nature of `serde_json::Value`, which means you're losing out on the fantastic type system that Rust offers.

But what I've been working on in `mwapi_responses` is a third option: having a Rust macro generate the response structs based on the specified query parameters. Here's an example from the documentation:

	:::rust
	use mwapi_responses::prelude::*;
	#[query(
	    prop="info|revisions",
	    inprop="url",
	    rvprop="ids"
	)]
	struct Response;

This expands to roughly:

	:::rust
	#[derive(Debug, Clone, serde::Deserialize)]
	pub struct Response {
	    #[serde(default)]
	    pub batchcomplete: bool,
	    #[serde(rename = "continue")]
	    #[serde(default)]
	    pub continue_: HashMap<String, String>,
	    pub query: ResponseBody,
	}
	
	#[derive(Debug, Clone, serde::Deserialize)]
	pub struct ResponseBody {
	    pub pages: Vec<ResponseItem>,
	}
	
	#[derive(Debug, Clone, serde::Deserialize)]
	pub struct ResponseItem {
	    pub canonicalurl: String,
	    pub contentmodel: String,
	    pub editurl: String,
	    pub fullurl: String,
	    pub lastrevid: Option<u32>,
	    pub length: Option<u32>,
	    #[serde(default)]
	    pub missing: bool,
	    #[serde(default)]
	    pub new: bool,
	    pub ns: i32,
	    pub pageid: Option<u32>,
	    pub pagelanguage: String,
	    pub pagelanguagedir: String,
	    pub pagelanguagehtmlcode: String,
	    #[serde(default)]
	    pub redirect: bool,
	    pub title: String,
	    pub touched: Option<String>,
	    #[serde(default)]
	    pub revisions: Vec<ResponseItemrevisions>,
	}
	
	#[derive(Debug, Clone, serde::Deserialize)]
	pub struct ResponseItemrevisions {
	    pub parentid: u32,
	    pub revid: u32,
	}

It would be a huge pain to have to write that out by hand every time, so having the macro do it is really convenient.

The crate is powered by [JSON metadata files](https://gitlab.com/legoktm/mwapi/-/tree/master/mwapi_responses_derive/data) for each API module, specifying the response fields and which parameters need to be enabled to
have them show up in the output. And there are some uh, creative methods on how to represent Rust types in JSON so they can be spit out by the macro. So far I've been writing the JSON files by hand by testing each
parameter out manually and then reading the MediaWiki API source code. I suspect it's possible to automatically generate them, but I haven't gotten around to that yet.

## Using enums?

So far the goal has been to faithfully represent the API output and directly map it to Rust types. This was my original goal and I think a worthwhile one because it makes it easy to figure out what the macro is doing.
It's not really convenient to dump the structs the macro creates (you need a tool like [cargo-expand](https://lib.rs/crates/cargo-expand)), but if you can see the API output, you know that the macro is generating the
exact same thing, but using Rust types.

There's a big downside to this, which is mostly that we're not able to take full advantage of the Rust type system. In the example above, lastrevid, length, pageid and touched are all typed using `Option<T>`, because
if the page is missing, then those fields will be absent. But that means we need to `.unwrap()` on every page after checking the value of the missing property. It would be much better if we had ResponseItem split into
two using an enum, one for missing pages and the other for those that exist.

	:::rust
	enum ResponseItem {
	    Missing(ResponseItemMissing),
	    Exists(ResposneItemExists)
	}

This would also be useful for properties like `rvprop=user|userid`. Currently setting that property results in something like:

	:::rust
	pub struct ResponseItemrevisions {
	    #[serde(default)]
	    pub anon: bool,
	    pub user: Option<String>,
	    #[serde(default)]
	    pub userhidden: bool,
	    pub userid: Option<u32>,
	}

Again, `Option<T>` is being used for the case where the user is hidden, and those properties aren't available. Instead we could have something like:

	:::rust
	enum RevisionUser {
	    Hidden,
	    Visible { username: String, id: u32 }	
	}

(Note that anon can be figured out by looking at `id == 0`.) Again, this is much more convenient than the faithful representation of JSON.

I'm currently assuming these kinds of enums can be made to work with serde, or maybe we'll need some layer on top of that. I'm also still not sure whether we want to lose the faithful representation aspect of this.

## Next steps

The main next step is to get this crate used in some real world projects and see how people end up using it and what the awkward/bad parts are. One part I've found difficult so far is that these types are literally just types,
there's no integration with any API library, so it's all up to the user on how to figure that out. There's also currently no logic to help with continuing queries, I might look into adding some kind of merge() function
to help with that in the future.

I have some very very [proof-of-concept integration](https://gitlab.com/legoktm/mwapi/-/commit/579d0f133c53e5cf9ff9ea658a5eca8208fe38d1) code with my mwbot project, more on that to come in a future blog post.

Contributions are welcome in all forms! For questions/discussion, feel free to join `#wikimedia-rust:libera.chat` (via Matrix or IRC) or use the project's issue tracker.

To finish on a more personal note, this is easily the most complex Rust code I've written so far. proc-macros are super powerful, but it's super easy to get lost writing code that just writes more code. It feels like it's been
through at least 3 or 4 rounds of complex refactoring, each taking advantage of new Rust things I learn, generally making the code better and more robust. The [code coverage metrics](https://legoktm.gitlab.io/mwapi/coverage/)
are off because it's split between two crates, the code is actually fully 100% covered by integration+unit tests.
