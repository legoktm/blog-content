Title: PHPCS now voting on MediaWiki core
Date: 2015-09-27 07:02
Category: MediaWiki
Tags: mediawiki, phpcs

I [announced](https://lists.wikimedia.org/pipermail/wikitech-l/2015-September/083392.html) earlier today that PHP CodeSniffer is now a voting job against all submitted MediaWiki core patches. This is the result of a lot of hard work by a large number of people.

Work on PHPCS compliance usually comes in bursts, most recently I was motivated after a closing PHP tag (<code>?></code>) made it into our codebase, which easily could have been a huge issue.

PHPCS detects most code style issues as per our [coding conventions](https://www.mediawiki.org/wiki/Manual:Coding_conventions/PHP) using an enhanced PHP parser, "sniffs" written by upstream, and our own set of [custom sniffs](https://packagist.org/packages/mediawiki/mediawiki-codesniffer). The goal is to provide faster feedback to users about routine errors, instead of requiring a human to point them out.

There's still work to be done though, we made it voting by disabling some sniffs that were failing. Some of those are going to take a lot of work to enable (like maximum line length), but it's a huge accomplishment to get a large portion of it voting.

We also [released](https://lists.wikimedia.org/pipermail/wikitech-l/2015-September/083391.html) MediaWiki-CodeSniffer 0.4.0 today, which is the versioned ruleset and custom sniffs. It has experimental support for automatically fixing errors that PHPCS spots, which will make it even easier to fix style issues.
