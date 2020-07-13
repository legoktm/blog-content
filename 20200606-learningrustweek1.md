Title: Learning Rust, week 1
Date: 2020-06-06 00:11:50
Category: Tech
Tags: rust

I'm trying to learn [Rust](https://en.wikipedia.org/wiki/Rust_(programming_language)) this summer. I've found I learn languages the best by just trying to do something in it, figuring out the building blocks as I go along. So I plan on writing/porting different projects to Rust.

This week I set up [rustup](https://rustup.rs/), installed the stable and nightly toolchains and started getting familiar with cargo/the build system.

I [ported my newusers Toolforge tool](https://gerrit.wikimedia.org/r/c/labs/tools/newusers/+/601523) to Rust. It's a simple web server with a single route that makes an API request, and dumps the output in plaintext.

I picked the `rocket` framework because it seemed more straightforward and similar to Python's Flask compared to `hyper`, but it was a bit weird to me that it required a nightly build of Rust to compile and run (though [it's apparently about to change](https://github.com/SergioBenitez/Rocket/issues/19)). I also used Magnus's `mediawiki` crate mostly to see what it was like, this API request was so simple I didn't really need any MediaWiki-specific code. Thank you to `qedk` in `#wikimedia-tech` who helped [work around](https://github.com/magnusmanske/mediawiki_rust/pull/21) a dependency issue I ran into.

I also [wrote up an analysis of supporting Rust tools on Toolforge](https://phabricator.wikimedia.org/T194953#6183849) in the future.

Code written:

* [newusers Toolforge tool](https://gerrit.wikimedia.org/r/plugins/gitiles/labs/tools/newusers/+/master) (~40 lines)

Libraries used:

* [rocket](https://rocket.rs/)
* [mediawiki](https://github.com/magnusmanske/mediawiki_rust)

Concepts learned:

* [`Result` and `.unwrap()` and `.expect()`](https://doc.rust-lang.org/book/ch09-02-recoverable-errors-with-result.html). Still figuring out the `?` one.
* Going from `Vec` to an iterator and back to a `Vec` via `.iter()` and `.collect()`.

Next week:

* Writing a command-line tool.
