Title: Introducing mwmon
Date: 2015-10-26 05:58
Category: MediaWiki
Tags: mediawiki, monitoring

Ocassionally some of the MediaWiki wikis I help maintain would go down, usually due to heavy traffic or a DoS of some kind. Sometimes Apache would be overloaded, or even MySQL being hammered (I'm looking at you DPL).

When this was happening around WikiConference USA time to that wiki, I wrote a quick Python script that would text me whenever it went down.

I've now generalized that script to be more easily configurable, and support an arbitrary number of wikis, named [mwmon](http://git.legoktm.com/legoktm/mwmon), which now features a basic web frontend.

For each wiki, it checks that the home page, Special:BlankPage, and the API are responding. Ideally the home page check will test the cache, BlankPage will hit MediaWiki directly, and the API is used to get the version that is installed.

Notifications are delivered over email, which I have configured to use AT&T's email to text gateway (@txt.att.net), so it'll go to my phone.

* [Source code](http://git.legoktm.com/legoktm/mwmon)
* [Example web frontend](http://legoktm.com/monitor/)

