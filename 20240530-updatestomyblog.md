Title: Updates to my blog
Date: 2024-05-30 06:22:20
Category: Meta
Tags: pelican, b2, rust

It's been nearly 10 years since I [created](/2014/11/21/first.html) this blog
and for that entire time it's been using the [Pelican](https://getpelican.com/)
static site generator. It's been pretty good, but lately I've wanted to improve
and change some things, so I've taken the opportunity to rewrite it from
mostly scratch.

[`b2`](https://git.legoktm.com/legoktm/b2) is a Rust program that takes
an input folder of markdown files and spits out a complete HTML directory
of the blog. The templates and theme are taken from my [fork of pelican-sober](https://github.com/legoktm/pelican-sober/tree/changes).
For the most part nothing has changed, I've just taken the opportunity to
adjust the CSS and improve some of the HTML output.

`b2` is pretty specific for my usecase, I'm not planning to turn it into a
general purpose static site generator, though you're more than welcome to
fork it for your own needs.
