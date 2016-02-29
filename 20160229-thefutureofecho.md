Title: The future of Echo
Date: 2016-02-29 07:29
Category: MediaWiki

Echo (aka "Notifications") is the MediaWiki extension that provides a notifications framework for other features to use, as well as some "core" notification types. It's had a tumultuous history ever since it was deployed to Wikimedia wikis in 2013. To figure out where Echo should go, I think we have to look at its history first.

The initial deployment was pretty rough. The [OBOD](https://meta.wikimedia.org/wiki/New_messages_notification) was gone, but no replacement. Standard APIs like [hasmsg=1](https://www.mediawiki.org/wiki/API:Userinfo) didn't work either. The development team (WMF's "E2" team) iterated on those, improved the API integration and added a newer and less obtrusive new messages indicator (while also designing my personal favorite, [nerdalert.js](https://en.wikipedia.org/wiki/User:Kaldari/nerdalert.js)). So the time came for the deployment to be expanded to all Wikimedia wikis, at which point nearly the entire development team switched over to a different project (Flow), leaving one engineer to supervise the rollout over all projects. Umm, what???

So we ended up with bugs like "[Mention notifications don't work if the sender's signature contains localized namespaces](https://phabricator.wikimedia.org/T55132)" taking nearly 5 full months to fix. That sucked.

Anyways, Echo was mostly dormant until mid-2014, when the "Core features" (previously E2) team made changes to Echo to support having Flow notifications go in a separate pane in the flyout. Except Flow was barely used at this point, so no one noticed outside of mediawiki.org really. (I was technically on the core features team at this point, but mostly doing Flow API things IIRC). But after a month or two most of the development moved back to Flow.

And then finally after the great engineering re-org of 2015, the Collaboration team (formerly Core features, but you already guessed that ;-)) also started looking at Echo seriously, and starting to fix some of the issues that had piled up over the years, including splitting the alerts and messages flyouts properly, giving user talk messages more prominence, and eventually embarking upon cross-wiki notifications.

Despite barely getting any attention from developers (until now really), Echo remains the most popular and really *only* successful product to come out of the E2/Core features/Collaboration team. Why?

The most useful feature of Echo is definitely the mention notifications which allow you to "ping" other users. So instead of people having to watchlist giant pages and look through history to see if anyone responded to the one thread they want to follow, they can wait for the notification that someone pinged them while responding. The once widely used <code>{{talkback}}</code> template is now deprecated in favor of these notifications. And for most users, this functionality is good enough. Watchlists really haven't seen any major changes in the past few years (again, until the past month, but that's another story), so something else that can do the job was welcomed by users.

So now we're in the state where we have two overlapping, but not exactly the same features: Notifications and Watchlists. [Gryllida](https://www.mediawiki.org/wiki/User:Gryllida) has written up an RfC titled "[Need to merge Notifications and Watchlist or lack thereof](https://www.mediawiki.org/wiki/Requests_for_comment/Need_to_merge_Notifications_and_Watchlist_or_lack_thereof)", discussing some of the similarities and differences. Over the next few months I'd like to flesh out the RfC a bit more and work on a solid proposal.

I also wrote an RfC yesterday titled "[Notifications in core](https://www.mediawiki.org/wiki/Requests_for_comment/Notifications_in_core)", which discusses merging parts of the Echo extension into MediaWiki core. I think this is crucial in improving the usability of notifications from both a user and developer perspective, as well as improving the architecture by requiring less hacks. And it can probably be done before the reconciliation of notifications and watchlists.

So, that's where I think Echo should go in the next year or two. I probably won't have time to actually work on this, so we'll see!
