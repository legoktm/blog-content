Title: Two steps forward, one step back for mwbot-rs
Date: 2023-01-24 12:22:58
Category: MediaWiki
Tags: mwbot-rs, rust, parsoid, kuchiki

I was intending to write a pretty different blog post about progress on [mwbot-rs](https://www.mediawiki.org/wiki/Mwbot-rs) but...ugh. The main dependency of the `parsoid` crate, `kuchiki`, [was archived](https://github.com/kuchiki-rs/kuchiki) over the weekend.
In reality it's been lightly/un-maintained for a while now, so this is just reflecting reality, but it does feel like a huge setback. Of course, I only have gratitude for [Simon Sapin](https://github.com/SimonSapin), the
primary author and maintainer, for starting the project in the first place.

`kuchiki` was a crate that let you manipulate HTML as a tree, with various ways of iterating over and selecting specific DOM nodes. `parsoid` was really just a wrapper around that, allowing you get to get a `WikiLink` node
instead of a plain `<a>` tag node. Each "WikiNode" wrapped a `kuchiki::NodeRef` for convenient accessors/mutators, but still allowed you to get at the underlying node via `Deref`, so you could manipulate the HTML directly even if the
`parsoid` crate didn't know about/support something yet.

This is not an emergency by any means, `kuchiki` is pretty stable, so in the short-term we'll be fine, but we do need to find something else and rewrite `parsoid` on top of that. Filed [T327593](https://phabricator.wikimedia.org/T327593)
for that.

I am mostly disappointed because have cool things in the pipeline that I wanted to focus on instead. The new `toolforge-tunnel` CLI is probably ready for a general announcement and was largely worked on by
[MilkyDefer](https://www.mediawiki.org/wiki/User:MilkyDefer). And I also have [upload support](https://gitlab.wikimedia.org/repos/mwbot-rs/mwbot/-/merge_requests/17) mostly done, I'm just trying to see if I can avoid
a breaking change in the underlying `mwapi_errors` crate.

In short: ugh.
