Title: Learning Rust, week 5
Date: 2020-07-13 06:29:33
Category: Tech
Tags: rust

I'm skipped writing a post for week 4 and then didn't do any Rust related things for a week, so this is my week 5 update.

The main (published) Rust I've written since my last post is a port of my [w.wiki statistics](https://shorturls.toolforge.org/) Toolforge tool. It reads through compressed plaintext dumps, parses URLs and aggregates counts per-domain to make a nice table. I used the flate2 crate for decompressing gzipped files and then the `std::io::BufRead` trait to read a file line-by-line.

It also has a slow-to-load chart that shows the increase in total shortened URLs since the start of the service. After looking through a few different plotting libraries, I ended up using [plotters](https://crates.io/crates/plotters) because it could properly chart timescale graphs. I think the graphs created by the [charts](https://crates.io/crates/charts) crate look prettier but it wasn't flexible enough for this dataset. The chart is slow to load on Toolforge because it reads ~60 cache files, needing to hit NFS for each one.

I want to move the cache to redis, but the primary Rust redis library [doesn't support having an automatic key prefix](https://github.com/mitsuhiko/redis-rs/issues/188) so I might end up writing a wrapper to do that.

In the future I want to provide charts for the individual domains and maybe a listing of recently shortened links for each domain, we'll see.

Because of how rocket's template system wants its structs to be serde-serializable, it becomes really straightforward to create a JSON API for every template-based endpoint. I had written a whole library ([flask-dataapi](https://pypi.org/project/flask-dataapi/)) for this in Python, and now it's basically built-in.

I also submitted two OAuth2-related patches to Rust crates:

* mediawiki - [Support authenticating with an OAuth2 access token](https://github.com/magnusmanske/mediawiki_rust/pull/29)
* rocket_oauth2 - [Add Wikimedia as a provider](https://github.com/jebrosen/rocket_oauth2/pull/16)

In terms of documentation, I've spent a decent amount of time improving my [Rust on Toolforge](https://wikitech.wikimedia.org/wiki/User:Legoktm/Rust_on_Toolforge) wiki page, including some updates that came after debugging with other Rust users on IRC. I think it's in a state that we can link to it from the official Toolforge docs.

