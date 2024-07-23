Title: Building a less terrible URL shortener
Date: 2024-07-23 05:33:14
Category: MediaWiki
Tags: wwiki, mediawiki, urlshortener

The [demise of goo.gl](https://developers.googleblog.com/en/google-url-shortener-links-will-no-longer-be-available/) is a good opportunity to write about how we built a less terrible URL shortener for Wikimedia projects: [w.wiki](https://w.wiki/). (I actually started writing this blog post in [2016](https://meta.wikimedia.org/w/index.php?title=Wikimedia_Blog/Drafts/Introducing_w.wiki&oldid=15805022) and never got back to it, oops.)

URL shorteners are generally a bad idea for a few main reasons:

1. They obfuscate the actual link destination, making it harder to figure out where a link will take you.
2. If they disappear or are shut down, the link is broken, even if the destination is fully functional.
3. They often collect extra tracking/analytics information.

But there are also legitimate reasons to want to shorten a URL, including use in printed media where it's easier for people to type a shorter URL. Or circumstances where there are restrictive character limits like tweets and IRC topics.
The latter often affects non-ASCII languages even more when limits are measured in bytes instead of Unicode characters.

At the end of the day, there was still [considerable demand](https://meta.wikimedia.org/wiki/Community_Wishlist_Survey_2019/Reading/Create_URL_Shortener_extension_for_Wikimedia_wikis) for a URL shortener, so we figured we could provide one that was well, less terrible. Following a [RfC](https://www.mediawiki.org/wiki/Requests_for_comment/URL_shortener),
we adopted [Tim's proposal](https://www.mediawiki.org/wiki/Requests_for_comment/URL_shortener#Tim.27s_implementation_suggestion), and a plan to avoid the aforementioned flaws:

1. Limit shortening to Wikimedia-controlled domains, so you have a general sense of where you'd end up. (Other generic URL shorteners are banned on Wikimedia sites because they bypass our [domain-based spam blocking](https://www.mediawiki.org/wiki/Extension:SpamBlacklist).)
2. [Proactively provide dumps](https://phabricator.wikimedia.org/T116986) as a guarantee that if the service ever disappeared, people could still map URLs to their targets. You can find them on [dumps.wikimedia.org](https://dumps.wikimedia.org/other/shorturls/) and they're mirrored to the [Internet Archive](https://phabricator.wikimedia.org/T257782#6376253).
3. Intentionally avoid any extra tracking and metrics collection. It is still included in Wikimedia's general [webrequest](https://wikitech.wikimedia.org/wiki/Data_Platform/Data_Lake/Traffic/Webrequest) logs, but there is no dedicated, extra tracking for short URLs besides what every request gets.

Anyone can create short URLs for any approved domain, subject to some rate limits and anti-abuse mechanisms via a special page or the API.

All of this is [open source](https://gerrit.wikimedia.org/g/mediawiki/extensions/UrlShortener/+/refs/heads/master) and usable by any MediaWiki wiki by installing the [UrlShortener extension](https://www.mediawiki.org/wiki/Extension:UrlShortener).
(Since this launched, additional functionality was added to use multiple character sets and generate QR codes.)

The dumps are nice for other purposes too, I use them to provide [basic statistics](https://shorturls.toolforge.org/) on how many URLs have been shortened.

I still tend to have a mildly negative opinion about people using our URL shortner, but hey, it could be worse, at least they're not using `goo.gl`.

