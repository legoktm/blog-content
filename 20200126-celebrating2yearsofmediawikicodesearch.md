Title: Celebrating 2 years of MediaWiki codesearch
Date: 2020-01-26 10:50:45
Category: MediaWiki
Tags: codesearch, mediawiki, puppet

<center>

![MediaWiki codesearch logo](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/MediaWiki_codesearch_logo.svg/200px-MediaWiki_codesearch_logo.svg.png)
</center>

It's been a little over 2 years since I [announced](https://lists.wikimedia.org/pipermail/wikitech-l/2017-December/089305.html) [MediaWiki codesearch](https://codesearch.wmflabs.org/search/ ), a fully free software tool that lets people make regex searches across all the MediaWiki-related code in Gerrit and much more. While I expected it to be useful to others, I didn't anticipate how popular it would become.

My goal was to replace the usage of the proprietary GitHub search that many MediaWiki developers were using due to lack of a free software alternative, but doing so meant that it needed to be a superior product. One of the biggest complaints about searching via GitHub was that it pulled in a lot of extraneous repositories, making it hard to search just MediaWiki extensions or skins.

codesearch is based on [hound](https://github.com/hound-search/hound/), a code search engine written in go, originally maintained by etsy. It took me all of 10 minutes to get an initial prototype working using the upstream docker image, but I ran into an issue pretty quickly: the repository selector didn't scale to our then-500+ git repositories (now we're at more like 900!). So it wouldn't really be possible to just search extensions easily.

After searching around for other upstream code search engines and not having much luck finding things I liked, I went back to hound and instead tried running multiple instances at once and it more or less worked. I [wrote](https://gerrit.wikimedia.org/r/c/labs/codesearch/+/399365) a small ~50 line Python proxy to wrap around the different hound instances and provide a unified UI. The proxy was sketch enough that I wrote "Please don't hurt me." in the commit message!

But it seems to have held up over time, surprisingly well. I attribute that to having systemd manage everything and the fact that hound is abandoned/unmaintained/dead upstream, creating a very stable platform, for better or worse. We've worked around most of the upstream bugs so I usually pretend it's a feature. But if it doesn't get adopted sometime this year I expect we'll create our own fork or adopt someone else's.

I recently used the anniversary to work on [puppetizing codesearch](https://phabricator.wikimedia.org/T242319) so there would be even less manual maintenance work in the future. Shoutout to Daniel Zahn (mutante) for all of his help in reviewing, fixing up and merging [all the puppet patches](https://gerrit.wikimedia.org/r/q/topic:codesearch+project:operations%252Fpuppet). All of the package installation, systemd units and cron jobs are now declared in puppet - it's really straightforward.

For those interested, I've [documented](https://www.mediawiki.org/wiki/Codesearch/Admin) the architecture of codesearch, and started writing more comprehensive docs on how to add a new search profile and how to add a new instance.

Here's to the next two years of MediaWiki codesearch.
