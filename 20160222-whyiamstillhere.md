Title: Why I am still here.
Date: 2016-02-22 08:58
Category: MediaWiki
Tags: notifications, wikimedia

This is a follow up to my probably depressing blog post on Friday, entitled "Why am I still here?" I think I figured out the answer, it's a lot of different things!

* [Because we give a damn.](https://twitter.com/g_gerg/status/700709939405172736)
* Because if I left, I'd still spend my days lurking on IRC, fixing things, and building (hopefully) cool things.
* [Because I still have some awesome things I promised to build and haven't finished yet.](https://twitter.com/hexmode/status/700666334950985729)
* And because all of you are totally awesome, and because I will [defend](http://meatballwiki.org/wiki/DefendEachOther) all of you as needed. &lt;3

So now that you're here, lets talk about something happy: cross-wiki notifications!

In 2013, notifications were introduced and collected events that users wanted to know about in a flyout. The initial response was that it looked like Facebook (it really did), and anger (well I'm not sure what the right emotion was) that the "[Orange Bar of Death](https://meta.wikimedia.org/wiki/New_messages_notification)" was gone. But the longer term impact has been a significant change to how on-wiki discussions work. One of the new features was that users can get "pinged" when someone links their username in a discussion comment. These days usage of templates like {{[talkback](https://en.wikipedia.org/wiki/Template:Talkback)}} is extremely rare, and entirely replaced with pinging.

So, cross-wiki notifications. This has been a long requested feature request, and I had actually written an [RfC](https://www.mediawiki.org/wiki/Requests_for_comment/Cross-wiki_notifications) about implementing it long before I was on the team tasked with implementing it (well, technically I was on the E2 team at that time, but history is confusing). Of course, I would be remiss to mentoin that most editors already have a cross-wiki notification system through their email inbox. Regardless, [some people are so excited they didn't even read the announcement](https://commons.wikimedia.org/w/index.php?title=Commons:Village_pump&oldid=187732375#Cross-wiki_notifications_available_as_a_Beta_feature_on_Wikimedia_Commons.C2.A0by_February_19th). ;-)

However, there were some limitations in the architecture that made expanding it for cross-wiki usage difficult. The most significant was that the formatting system was designed for specific types of notifications, hard to extend, and most importantly, difficult for developers to understand. We probably could have hacked our way around it, but the extensability was going to be a serious problem. And if we were going to touch some code, we should leave it better than we found it. :)

So, what to replace it with? I came up with a [presentation model system](https://phabricator.wikimedia.org/T107823#1554680) that every notification type would implement. This made it much easier to follow instead of the old data-driven style of formatters. We also built an [API](https://en.wikipedia.org/w/api.php?action=query&meta=notifications&notformat=model) (sorry, logged in users only) around it, so the frontend code can handle all of the display, and not have to parse out HTML to figure out the notification icon (yes, it used to do that :().

So now...going cross-wiki. We effectively had two approaches we could do, the first being created a central database table that all notifications went into, and then having each wiki read from it. This provided some logistical problems like checking revdel status, page existence, and local message overrides. The other approach was to make API requests to other wikis, and then merge the output into the flyout. We ended up going with the second one (cross-wiki API requests) after seeing [crosswatch](http://tools.wmflabs.org/crosswatch/) in action, which used the same strategy for its implementation of cross-wiki notifications.

We created a database tracking table which contains the number of unread alerts and messages you have on each wiki, so it would be known on what wikis to query notifications for. We also realized we could make these requests client-side (using CORS) for now, and move them server-side later.

And that's pretty much it. There were also some significant frontend changes, like converting it all to use [OOjs UI](https://www.mediawiki.org/wiki/OOjs_UI), but I didn't really work on those, and can't speak much about them.

<s>So, go to Special:BetaFeatures on your favorite wiki, check "enhanced notifications", and let us know what you think! And if it's not on your wiki yet, nag someone in #wikimedia-collaboration on freenode!</s>

Update: The list of wikis where it is available are listed on [MediaWiki.org](https://www.mediawiki.org/wiki/Help:Notifications/Cross-wiki#Release_timeline), and it should hit all other wikis by the end of March.
