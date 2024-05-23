Title: Measuring the length of Wikipedia articles
Date: 2023-02-25 04:23:02
Category: MediaWiki
Tags: rust, mwbot, wikipedia_prosesize, wikipedia, parsoid

There was recently [a request](https://en.wikipedia.org/w/index.php?title=Wikipedia_talk:Database_reports&oldid=1141414641#New_report_request:_FAs_by_length)
to generate a report of [featured articles](https://en.wikipedia.org/wiki/Wikipedia:Featured_articles) on Wikipedia, sorted by length, specifically the "prose size". It's pretty straightforward to get
a page's length in terms of the wikitext or even the rendered HTML output, but counting just the prose is more difficult. Here's how the "[Readable prose](https://en.wikipedia.org/wiki/Wikipedia:Article_size#Readable_prose)"
guideline section defines it:

<blockquote>
Readable prose is the main body of the text, excluding material such as footnotes and reference sections ("see also", "external links", bibliography, etc.), diagrams and images, tables and lists, Wikilinks and external URLs, and formatting and mark-up. 
</blockquote>

Why do Wikipedians care? Articles that are too long just won't be read by people. A little bit further down on that page, there are [guidelines on page length](https://en.wikipedia.org/wiki/Wikipedia:Article_size#A_rule_of_thumb).
If it's more than 8,000 words it "may need to be divided", 9,000 words is "probably should be divided" and 15,000 words is "almost certainly should be divided"!

Featured articles are supposed to be the best articles Wikipedia has to offer, so if some of them are too long, that's a problem!

## The results

The "[Featured articles by size](https://en.wikipedia.org/wiki/Wikipedia:Database_reports/Featured_articles_by_size)" report now updates weekly. As of the Feb. 22 update, the top five articles are:

1. [Elvis Presley](https://en.wikipedia.org/wiki/Elvis_Presley): 18,946 words
2. [Ulysses S. Grant](https://en.wikipedia.org/wiki/Ulysses_S._Grant): 18,847 words
3. [Douglas MacArthur](https://en.wikipedia.org/wiki/Douglas_MacArthur): 18,632 words
4. [Manhattan Project](https://en.wikipedia.org/wiki/Manhattan_Project): 17,803 words
5. [History of Poland (1945–1989)](https://en.wikipedia.org/wiki/History_of_Poland_(1945%E2%80%931989)): 17,843 words

On the flip side, the five shortest articles are:

1. [Si Ronda](https://en.wikipedia.org/wiki/Si_Ronda): 639 words
2. [William Feiner](https://en.wikipedia.org/wiki/William_Feiner): 665 words
3. [2005 Azores subtropical storm](https://en.wikipedia.org/wiki/2005_Azores_subtropical_storm): 668 words
4. [Miss Meyers](https://en.wikipedia.org/wiki/Miss_Meyers): 680 words
5. [Myriostoma](https://en.wikipedia.org/wiki/Myriostoma): 682 words

In case you didn't click yet, *Si Ronda* is a presumed lost 1930 silent film from the Dutch East Indies. Knowing that, it's not too surprising that the article is so short!

When I posted this on Mastodon, Andrew [posted charts comparing](https://mastodon.flooey.org/@generalising/109871137347419873) prose size in bytes vs word count vs wikitext size, showing how much of the wikitext markup is well, markup, and not the words
shown in the article.

## Lookup tool

So creating the report is exactly what had been asked. But why stop there? Surely people want to be able to look up the prose size of arbitrary articles that they're working to improve.
Wikipedia has a few tools to provide this information (specifically the [Prosesize gadget](https://en.wikipedia.org/wiki/Wikipedia:Prosesize) and [XTools Page History](https://xtools.wmflabs.org/articleinfo)), but unfortunately
both implementations suffer from bugs that I figured creating another might be useful.

Enter [prosesize.toolforge.org](https://prosesize.toolforge.org/). For any article, it'll tell you the prose size in bytes and word count. As a bonus, it highlights exactly which parts of the article are being counted and which
aren't. An API is also available if you want to plug this information into something else.

## How it works

We grab the [annotated HTML](https://www.mediawiki.org/wiki/Specs/HTML) (aka "Parsoid HTML") for each wiki page. This format is specially annotated to make it easier to parse structured information out of wiki pages.
The [parsoid](https://lib.rs/crates/parsoid) Rust crate makes it trivial to operate on the HTML. So I published a "[wikipedia_prosesize](https://lib.rs/crates/wikipedia_prosesize)"
crate that takes the HTML and calculates the statistics.

The [code](https://gitlab.wikimedia.org/repos/mwbot-rs/mwbot/-/blob/main/wikipedia_prosesize/src/lib.rs) is pretty simple, it's less than 150 lines of Rust.

First, we remove HTML elements that shouldn't be counted. This currently is:

* inline `<style>` tags
* the `#coordinates` element
* elements with a class of `*emplate` (this is supposed to match a variety of templates)
* math blocks, which have `typeof="mw:Extension/math"`
* references numbers (specfically the `[1]`, not the reference itself), which have `typeof="mw:Extension/ref"`

Then we find all nodes that are top-level text, so blockquotes don't count. In CSS terms, we use the selector `section > p`. For all of those we add up the length of the [text content](https://developer.mozilla.org/en-US/docs/Web/API/Node/textContent)
and count the number of words (by splitting on spaces).

I mentioned that the other tools have bugs, the Prosesize gadget ([source](https://en.wikipedia.org/wiki/MediaWiki:Gadget-Prosesize.js#L-68))
doesn't discount math blocks, inflating the size of math-related articles, while XTools ([source](https://github.com/x-tools/xtools/blob/f69d1a0ae7990d409c154a6c569b7f7376d7093e/src/Model/ArticleInfoApi.php#L160))
doesn't strip `<style>` tags nor math blocks. XTools also detects references with
a regex, `\[\d+\]`, which won't discount footnotes that use e.g. `[a]`. I'll be filing bugs against both, suggesting that they use my tool's API to keep the logic centralized in one place. I don't mean to throw shade on these
implementations, but I do think it shows why having one centralized implementation would be useful.

Source code for [the database report](https://github.com/mzmcbride/database-reports/blob/main/dbreps2/src/enwiki/featuredbysize.rs) and the [web tool](https://gitlab.wikimedia.org/toolforge-repos/prosesize/-/blob/main/src/main.rs)
are both available and welcome contributions. :-)

## Next

I hope people find this interesting and are able to use it for some other analysises. I'd be willing to generate a dataset of prose size for every article on the English Wikipedia using a database dump if people
would actually make some use of it.
