Title: MassMessage hits 1,000 commits
Date: 2017-08-29 00:00
Category: MediaWiki

The [MassMessage MediaWiki extension](https://www.mediawiki.org/wiki/Extension:MassMessage) hit 1,000 commits today, following an update of the localization messages for the Russian language. MassMessage replaced a Toolserver bot that allowed sending a message to all Wikimedia wikis, by integrating it into MediaWiki and using the job queue. We also added some nice features like input validation and previewing. Through it, I became familiar with different internals of MediaWiki, including submitting a few core patches.

I made my [first commit](https://gerrit.wikimedia.org/r/#/c/74831/) on July 20, 2013. It would get a full rollout to all Wikimedia wikis on [November 19, 2013](https://gerrit.wikimedia.org/r/#/c/91344/), after a lot of help from MZMcBride, Reedy, Siebrand, Ori, and other MediaWiki developers.

I also mentored [User:wctaiwan](https://www.mediawiki.org/wiki/User:Wctaiwan), who worked on a Google Summer of Code project that added a [ContentHandler backend](https://www.mediawiki.org/wiki/Extension:MassMessage/Page_input_list_improvements) to the extension, to make it easier for people to create and maintain page lists. You can see it used by [The Wikipedia Signpost's subscription list](https://en.wikipedia.org/wiki/Wikipedia:Wikipedia_Signpost/Subscribe).

It's still a bit crazy to think that I've been hacking on MediaWiki for over four years now, and how much it has changed my life in that much time. So here's to the next four years and next 1,000 commits to MassMessage!
