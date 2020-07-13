Title: Learning Rust, week 3
Date: 2020-06-23 09:56:48
Category: Tech
Tags: rust

I'm a little behind with this update as it took me a little longer to prepare and launch my project: [diff-libraries](https://libup-diff.wmflabs.org/). I'm planning to write a more detailed post on that later, but it's my most involved Rust project so far. The webserver is powered by [Rocket](https://rocket.rs/) and it uses [diesel](https://diesel.rs/) for the SQL backend. I'm using [Tera templates](https://tera.netlify.app/), which feel like Jinja2 templates, but are missing some of the nice Flask integrations like `url_for`.

I've gotten a pretty good setup going with GitLab-CI now: [rust-ci-pipeline](https://gitlab.com/legoktm/rust-ci-pipeline) (the name and setup are inspired by what [Debian has](https://gitlab.com/legoktm/rust-ci-pipeline)). There are still a few problems with [cargo-tarpaulin](https://crates.io/crates/cargo-tarpaulin) segfaulting every now and then but I haven't been able to debug it yet.

I published my first real library crate too: [eventstreams](https://crates.io/crates/eventstreams) ([docs](https://docs.rs/eventstreams/)). It's a wrapper around Wikimedia's new recent changes feed. I think the fact that docs.rs automatically builds documentation for every single library on crates.io, with no extra action needed is a real game changer. Even the auto-generated documentation is super useful, and it makes authors more likely to fill in the documentation knowing that someone will actually read it.

My goal for this past week was to learn async, and I kind of did, I [ported subdown3 to be all async](https://gitlab.com/legoktm/subdown3/-/commit/21504db64adad94d6ec7195f049ede0508e51709). I think I get the basics, but eh, over it for now. The fact that `reqwest` didn't let me incrementally migrate from it's blocking mode to the async version was frustrating, because it meant I had to port the entire codebase over to async before I could even get any of it to run to verify I was heading in the right direction.

Code written/released:

* [diff-libraries](https://gerrit.wikimedia.org/r/plugins/gitiles/labs/libraryupgrader/+/master/diff-libraries/) (~430 lines)
* [eventstreams](https://gitlab.com/legoktm/eventstreams) (~420 lines)
* [rustc-simple-version](https://gitlab.com/legoktm/rustc-simple-version/) (~45 lines)
* [gerrit-grr](https://gitlab.com/legoktm/rust-grr) 2.1.0 and 2.2.0

Libraries used:

* [diesel](https://diesel.rs/)
* [tera](https://tera.netlify.app/)
* [sse-client](https://crates.io/crate/sse-client)

Concepts learned:

* async/await (beginner)
* `std::thread`
* [build.rs](https://doc.rust-lang.org/cargo/reference/build-scripts.html)
* visibility in libraries/modules (`pub`)

Next week:

* I want to have a better understanding of [lifetimes](https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html), especially with regards to threads.
* @janriemer [gave](https://mastodon.technology/@janriemer/104349927662648779) me some tips on mocking libraries that I still need to look into (thanks!).

