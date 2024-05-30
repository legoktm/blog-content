Title: What it takes to parse MediaWiki page titles...in Rust
Date: 2021-12-23 04:00:00
Category: MediaWiki
Tags: mediawiki, mwbot, mwtitle, rust

In the UseModWiki days, Wikipedia page titles were "CamelCase" and automatically linked (see [CamelCase and Wikipedia](https://en.wikipedia.org/wiki/Wikipedia:CamelCase_and_Wikipedia)).

[MediaWiki](https://www.mediawiki.org/wiki/MediaWiki) on the other hand uses the famous `[[bracketed links]]`, aka "free links". For most uses, page titles are the primary identifier of a page, whether it's in URLs for
external consumption or `[[Page title|internal links]]`. Consequently, there are quite a few different normalization and validation steps MediaWiki titles go through.

Myself and [Erutuon](https://en.wikipedia.org/wiki/User:Erutuon) have been working on a Rust library that parses, validates and normalizes MediaWiki titles: [`mwtitle`](https://lib.rs/crates/mwtitle). The first 0.1 release was
published earlier this week! It aims to replicate all of the PHP logic, but in Rust. This is just a bit harder than it seems...

First, let's understand what a MediaWiki title is. A complete title looks like: `interwiki:Namespace:Title#fragment` (in modern MediaWiki jargon titles are called "link targets").

The optional interwiki prefix references a title on another wiki. On most wikis, looking at [Special:Interwiki](https://en.wikipedia.org/wiki/Special:Interwiki) shows the list of possible interwiki prefixes.

[Namespaces](https://www.mediawiki.org/wiki/Help:Namespaces)  are used to distinguish types of pages, like articles, help pages, templates, categories, and so on. Each namespace has an accompanying "talk" namespace used for discussions related to those pages.
Each namespace also has an internal numerical ID, a canonical English form, and if the wiki isn't in English, localized forms. Namespaces can also have aliases, for example "WP:" is an alias for the "Wikipedia:" namespace.
The main article namespace (ns #0) is special, because its name is the empty string.

The actual title part goes through various normalization routines and is stored in the database with spaces replaced by underscores.

And finally the fragment is just a URL fragment that points to a section heading or some other anchor on pages.

There are some basic validation steps that MediaWiki does. Titles can't be empty, can't have a relative path (`Foo/../Bar`), can't start with a colon, can't have magic tilde sequences (`~~~`, this syntax is used for signatures), and
they can't contain illegal characters. This last one is where the fun begins, as MediaWiki actually allows users to configure what characters are allowed in titles:

```php
$wgLegalTitleChars = " %!\"$&'()*,\\-.\\/0-9:;=?@A-Z\\\\^_`a-z~\\x80-\\xFF+";
```

This then gets put into a regex like `[^$wgLegalTitleChars]`, which, if it matches, is an illegal character. This works fine if you're in PHP, except we're using Rust! Looking closely, you'll see that `/` is escaped, because it's used
as the delimiter of the PHP regex, except that's an error when using the [`regex`](https://docs.rs/regex) crate. And the byte sequences of `\x80-\xFF` mean we need to operate on bytes, when we really would be fine with just matching
against `\u0080-\u00FF`.

MediaWiki has some (IMO crazy) code that parses the regex to rewrite it into the unicode escape syntax so it can be used in JavaScript. [T297340](https://phabricator.wikimedia.org/T297340) tracks making this
better and I have a patch outstanding to hopefully make this easier for other people in the future.

Then there's normalization. So what kind of normalization routines does MediaWiki do?

One of the most obvious ones is that the first letter of a page title is uppercase. For example, the article about iPods is actually called "IPod" in the database (it has a [display title override](https://en.wikipedia.org/w/index.php?title=IPod&action=info)).
Except of course, for all the cases where this isn't true. Like on Wiktionaries, where the first letter is not forced to uppercase and "iPod" is actually "iPod" [in the database](https://en.wiktionary.org/w/index.php?title=iPod&action=info).

Seems simple enough, right? Just take the first character, call [`char.to_uppercase()`](https://doc.rust-lang.org/std/primitive.char.html#method.to_uppercase), and then merge it back with the rest of the characters.

Except...PHP uppercases characters differently and changes behavior based on the PHP and possibly ICU version in use. Consider the character `ᾀ` (U+1F80). When run through [`mb_strtoupper()`](https://www.php.net/manual/en/function.mb-strtoupper.php)
using PHP 7.2 ([3v4l](https://3v4l.org/lSLGn)), what Wikimedia currently uses, you get `ᾈ` (U+1F88). In Rust ([playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=fb95622ed76ec880ca697c6166c83bc6)) and
later PHP versions, you get `ἈΙ` (U+1F08 and U+0399).

For now we're storing a [map of these characters](https://gitlab.com/mwbot-rs/mwbot/-/blob/mwtitle-0.1.0/mwtitle/src/php.rs) inside `mwtitle`, which is terrible, but I filed a bug for exposing this via the API: [T297342](https://phabricator.wikimedia.org/T297342).

There's also a whole normalization routine that sanitizes IP addresses, especially IPv6. For example, `User talk:::1` normalizes to `User talk:0:0:0:0:0:0:0:1`.

Finally, adjacent whitespace is normalized down into a single space. But of course, MediaWiki uses its [own list of what whitespace is](https://gitlab.com/mwbot-rs/mwbot/-/blob/mwtitle-0.1.0/mwtitle/src/codec.rs#L482) which doesn't
exactly match [`char.is_whitespace()`](https://doc.rust-lang.org/std/primitive.char.html#method.is_whitespace).

We developed `mwtitle` by initially doing a line-by-line port of [`MediaWikiTitleCodec::splitTitleString()`](https://gerrit.wikimedia.org/g/mediawiki/core/+/8a5d31745dba569c5ec7bb27ec211602b7a8a927/includes/title/MediaWikiTitleCodec.php#333),
and discovering stuff we messed up or overlooked by copying test cases too. Eventually this escalated by writing a PHP extension wrapper, [`php-mwtitle`](https://gitlab.com/mwbot-rs/mwbot/-/tree/php-mwtitle/php-mwtitle) which could be plugged into MediaWiki for running MediaWiki's own test suite. And after a
few fixes, it fully passes everything.

Since I already wrote the integration, I ran some basic benchmarks, the Rust version is about 3-4x faster than MediaWiki's current PHP implementation (see the [raw perf measurements](https://phabricator.wikimedia.org/P18116#92451)).
But title parsing isn't particularly hot, so switching to the Rust version would probably result in only a ~0.5% speedup overall based on some rough estimations looking at [flamegraphs](https://performance.wikimedia.org/php-profiling/).
That's not really worth it, considering the social and tooling overhead of introducing a Rust-based PHP extension as a optional MediaWiki dependency.

For now `mwtitle` is primarily useful for people writing bots and other MediaWiki tools in Rust. Given that a lot of people tend to use Python for these tasks, we could look into using [PyO3](https://pyo3.rs/) to write a Python wrapper.

There's also generally a lot of cool code in `mwtitle`, including sets and maps that can perform case-insensitive matching without requiring string allocations (nearly all Erutuon's fantastic work!).

Throughout this process, we found a few bugs mostly by just staring at and analyzing this code over and over:

* [Dead code in `MediaWikiTitleCodec::getTitleInvalidRegex()` for checking XML/HTML character references](https://phabricator.wikimedia.org/T297578)
* [Allowing spaced slash after username or IP address in User or User talk namespace title is confusing](https://phabricator.wikimedia.org/T297539)
* [`Title::newMainPage()` doesn't split parser cache by UI language when `$wgForceUIMsgAsContentMsg = ['mainpage']`](https://phabricator.wikimedia.org/T297573)

And filed some that would make parsing titles outside of PHP easier:

* [`$wgLegalTitleChars` is hard to use outside PHP](https://phabricator.wikimedia.org/T297340)
* [Expose phpCharToUpper map for title normalization via the API](https://phabricator.wikimedia.org/T297342) (mentioned earlier)

`mwtitle` is one part of the new [`mwbot-rs` project](https://www.mediawiki.org/wiki/mwbot-rs), where we're building a framework for writing MediaWiki bots and tools in Rust the wiki way.
We're always looking for more contributors, please reach out if you're interested, either on-wiki, on [GitLab](https://gitlab.com/mwbot-rs/mwbot), or in the `#wikimedia-rust:libera.chat` room (Matrix or IRC).
