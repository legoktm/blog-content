Title: Learning Rust, week 2
Date: 2020-06-14 02:49:21
Category: Tech
Tags: rust

I think I'm starting to understand why people like Rust so much. The tooling, especially `rustup` and `cargo` are pretty fantastic. The fact that `rustfmt` (code auto-formatter), `clippy` (linter) and a test runner are all integrated through `cargo` is super convenient. I feel like Python used to have that with `setuptools`/`setup.py` but over time that's been lost.

This week I ported my Gerrit helper [grr](https://crates.io/crates/gerrit-grr) to Rust, and wrote a Reddit downloader tool, [subdown3](https://crates.io/crates/subdown3), that I originally wrote in Python nearly a decade ago. subdown3 has straightforward command-line options and primarily deals with URL parsing and hitting various APIs. grr is a convenience wrapper around git that just shells out.

I'm also hosting my Rust projects on GitLab, primarily to take advantage of its CI features (which I don't feel like setting up for git.legoktm.com). I've been using [cargo-tarpaulin](https://crates.io/crates/cargo-tarpaulin) to generate coverage for tests, which has been simple. No extra configuration or anything, you just run it.

One thing I've been struggling with is figuring out how to mock functions. Because grr primarily shells out to git, integration testing isn't that useful, but testing what exactly we're shelling out to is more useful.

Code written:

* [subdown3](https://gitlab.com/legoktm/subdown3) (~750 lines)
* [grr](https://gitlab.com/legoktm/rust-grr) (~425 lines)

Libraries used:

* [regex](https://crates.io/crates/clap)
* [reqwest](https://crates.io/crates/reqwest)
* [serde_json](https://crates.io/crates/serde_json)
* [clap](https://crates.io/crates/clap)

Concepts learned:

* iterators
* `std::process::Command`
* publishing stuff on [crates.io](https://crates.io/)

Next week:

* async

