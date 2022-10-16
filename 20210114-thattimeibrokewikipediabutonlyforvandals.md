Title: That time I broke Wikipedia, but only for vandals
Date: 2021-01-15 00:00:15
Category: MediaWiki
Tags: wikipedia, mediawiki, wikipedia20

As one of the top contributors to [MediaWiki](https://www.mediawiki.org/wiki/MediaWiki), the free wiki engine that powers Wikipedia, I'm often asked how I got started. To celebrate Wikipedia's [20th birthday](https://20.wikipedia.org/), here's that unfortuante story.

In late 2012, I was a bored college student who was spending most of his time editing Wikipedia. I reverted a lot of vandalism, and eventually began developing anti-vandalism IRC bots to allow patrollers like myself to respond to vandalism even faster than before.

I had filed a [bug request](https://static-bugzilla.wikimedia.org/42758) asking for the events from our anti-abuse "[edit filter](https://en.wikipedia.org/wiki/Wikipedia:Edit_filter)" to be broadcast to the realtime IRC recent changes feed (at the time the only way to get a [continuous, live feed of edits](https://wikitech.wikimedia.org/wiki/Irc.wikimedia.org). A few months later no one had implemented it and I was annoyed.

After complaining to a few people about this, they suggested I fix it myself. The code is all open source and I know how to program, what could go wrong?

It's at this point I should've told someone I didn't actually know PHP; I knew plenty of Python and had just learned Java in my intro to computer science class.

I really had no clue what I was doing, but I [submitted a patch](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/AbuseFilter/+/38501) that kind of looked right. I asked my friend [Ori](https://en.wikipedia.org/wiki/User:ATDT) to review it, and he promptly approved the change and deployed it on the real servers that power Wikipedia.

<figure>
<img src="https://blog.legoktm.com/images/af1.png" alt="The broken patch">
<figcaption>My very broken patch</figcaption>
</figure>

I was pretty excited, my first ever patch had been merged and deployed! The millions of people who visited Wikipedia every day would get served a page that included my code.

I then went to go test the change and it did. not. work. I made a test edit that I knew would trigger a filter, except instead of getting a notification from the realtime feed, I saw the Wikimedia Error screen.

In fact, for about 30 minutes any wannabe vandal (and a few innocent users) who triggered a filter would see the error page:

<figure>
<img src="https://blog.legoktm.com/images/wm_error.png" alt="Old Wikimedia error page">
<figcaption>This really wasn't a sustainable way to stop vandalism</figcaption>
</figure>

I immediately told Ori that it was broken and his reaction was along the lines of: "You didn't test it??" He had assumed I knew what I was doing and tested my code before submitting it...oops. He [very quickly](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/AbuseFilter/+/38658) fixed the issue for me, and then started teaching me how to properly test my patches.

<figure>
<img src="https://blog.legoktm.com/images/af2.png" alt="The one line fix">
<figcaption>The one line fix</figcaption>
</figure>

He introduced me to [MediaWiki-Vagrant](https://www.mediawiki.org/wiki/MediaWiki-Vagrant), a then-new project to automate setting up a development instance, which is now used by a majority of MediaWiki developers (I was user #2).

There were a lot of things that went wrong in this story that should have caught this failure before it ended up on our servers. We didn't have any automated testing or static analysis to point out my patch was obviously flawed. We didn't do a staged rollout to a few users first before exposing all of Wikipedia to it.

This incident has stuck in my head ever since and I'm pretty confident it couldn't happen today because we've implemented those safeguards. I've spent a lot of time developing better static analysis tools ([MediaWiki-CodeSniffer](https://gerrit.wikimedia.org/g/mediawiki/tools/codesniffer) and [phan](https://github.com/phan/phan) especially) and building [infrastructure](https://doc.wikimedia.org/cover-extensions/) to help us improve test coverage. We have proper canary deploys now, so these obvious errors should never make it to a full deployment.

It really sucked knowing that my patch had broken Wikipedia, but at the same it was invigorating. Getting my code onto one of the biggest websites in the world was actually pretty straightforward and within reach. If I learned a bit more PHP and actually tested my code first, I could fix bugs on my own instead of waiting for someone else to do it.

I think this mentality really represents one of my favorite parts about Wikipedia: if something is broken, [just fix it](https://en.wikipedia.org/wiki/Wikipedia:Be_bold).
