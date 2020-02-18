Title: Automatically rewriting links to use HTTPS on Wikimedia sites
Date: 2019-12-28 08:37:37
Category: MediaWiki
Tags: mediawiki, wikimedia, php, https

In March 2018, [Facebook began automatically rewriting links to use HTTPS using the HSTS preload list](https://www.facebook.com/notes/protect-the-graph/upgrades-to-facebooks-link-security/2015650322008442/). Now all Wikimedia sites (including Wikipedia) do the same.

If you're not familiar with it, the HSTS preload list tells browsers (and other clients) that the website should only be visited over HTTPS, not the insecure HTTP.

However, not all browsers/clients support HSTS and users stuck on old versions might have outdated versions of the list.

Following Facebook's lead, we first looked into the usefulness of adding such functionality to Wikimedia sites. My [analysis](https://git.legoktm.com/legoktm/hsts-analysis) from July 2018 indicated that 2.87% of links on the English Wikipedia would be rewritten to use HTTPS. I repeated the analysis in July 2019 for the German Wikipedia, which indicated 2.66% of links would be rewritten.

I developed the [SecureLinkFixer MediaWiki extension](https://www.mediawiki.org/wiki/Extension:SecureLinkFixer) ([source code](https://gerrit.wikimedia.org/g/mediawiki/extensions/SecureLinkFixer/+/master)) to do that in July 2018. We bundle a copy of the HSTS preload list (in PHP), and then add a hook to rewrite the link if it's on the list when the page is rendered.

The HSTS preload list is pulled from [mozilla-central](https://hg.mozilla.org/mozilla-central/file/tip/security/manager/ssl/nsSTSPreloadList.inc) (warning: giant page) weekly, and committed into the SecureLinkFixer repository. That update is deployed roughly every week to Wikimedia sites, where it'll take at worst a month to get through all of the caching layers.

(In the process we (thanks Michael) found a [bug with Mozilla not updating the HSTS list](https://bugzilla.mozilla.org/show_bug.cgi?id=1479918)...yay!) 

By the end of July 2019 the extension was deployed to all Wikimedia sites - the delay was mostly because I didn't have time to follow-up on it during the school year. Since then things have looked relatively stable from a performance perspective.

Thank you to Ori & Cyde for bringing up the idea and Reedy, Krinkle, James F & ashley for their reviews.
