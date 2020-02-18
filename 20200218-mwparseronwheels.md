Title: mwparser on wheels
Date: 2020-02-18 06:48:34
Category: MediaWiki
Tags: mwparserfromhell, mediawiki, python

[mwparserfromhell](https://github.com/earwig/mwparserfromhell/) is now fully [on wheels](https://en.wikipedia.org/wiki/User:TheBuddy92/Willy_on_Wheels:_A_Case_Study). Well...not those wheels - [Python wheels](https://pythonwheels.com/)!

If you're not familiar with it, mwparserfromhell is a powerful parser for MediaWiki's wikitext syntax with an API that's really convenient for bots to use. It is primarily developed and maintained by [Earwig](https://en.wikipedia.org/wiki/User:The_Earwig), who originally wrote it for their bot.

Nearly 7 years ago, [I implemented](https://www.mediawiki.org/wiki/Special:Code/pywikipedia/11737) opt-in support for using mwparserfromhell in [Pywikibot](https://www.mediawiki.org/wiki/Manual:Pywikibot), which is arguably the most used MediaWiki bot framework. About a year later, Merlijn van Deen [added it as a formal dependency](https://gerrit.wikimedia.org/r/c/pywikibot/core/+/131263), so that most Pywikibot users would be installing it...which inadvertently was the start of some of our problems.

mwparserfromhell is written in pure Python with an optional C speedup, and to build that C extension, you need to have the appropriate compiler tools and development headers installed. On most Linux systems that's pretty straightforward, but not exactly for Windows users (especially not for non-technical users, which many Pywikibot users are).

This brings us to Python wheels, which allow for easily distributing built C code without requiring users to have all of the build tools installed. Starting with v0.4.1 (July 2015), Windows users could download wheels from PyPI so they didn't have to compile it themselves. This resolved most of the complaints (along with [John Vandenberg's patch](https://github.com/earwig/mwparserfromhell/pull/94) to gracefully fallback to the pure Python implementation if building the C extension fails).

In November 2016, I [filed a bug](https://github.com/earwig/mwparserfromhell/issues/170) asking for Linux wheels, mostly because it would be faster. I thought it would be just as straightforward as Windows, until I looked into it and found [PEP 513](https://www.python.org/dev/peps/pep-0513/), which specified that basically, the wheels needed to be built on CentOS 5 to be portable enough to most Linux systems.

With the new Github actions, it's actually pretty straightforward to build these manylinux1 wheels - so a week ago I put together a [pull request](https://github.com/earwig/mwparserfromhell/pull/239) that did just that. On every push it will build the manylinux1 wheels (to test that we didn't break the manylinux1 compatibility) and then on tag pushes, it will upload those wheels to PyPI for everyone to use.

Yesterday [I did the same for macOS](https://github.com/earwig/mwparserfromhell/pull/240) because it was so straightforward. Yay.

So, starting with the 0.6.0 release (no date set yet), mwparserfromhell will have pre-built wheels for Windows, macOS and Linux users, giving everyone faster install times. And, nearly everyone will now be able to use the faster C parser without needing to make any changes to their setup.

