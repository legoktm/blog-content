Title: Wikipedia's new skin is a sad opportunity to reminisce what we could've had instead
Date: 2023-01-18 13:00:00
Category: MediaWiki
Tags: wikipedia, vector, mediawiki, timeless, skinning

By the time you read this, you'll probably have seen Wikipedia's new layout ("skin"), dubbed "Vector 2022". You can read about [the changes it brings](https://en.wikipedia.org/wiki/Wikipedia:Requests_for_comment/Deployment_of_Vector_(2022)/More_about_Vector_(2022)#New_features).

As with most design changes, some people will like it and some people won't. But me? I just feel sad because years ago we had a popular, volunteer-driven skin proposal that was shut down by arguments that today we now know were in
bad faith and hypocritical.

Back in 2012, then-Wikimedia Foundation senior designer [Brandon Harris aka Jorm](https://en.wikipedia.org/wiki/User:Jorm) pitched a new idea: "[The Athena Project: being bold](https://en.wikipedia.org/wiki/Wikipedia:Wikipedia_Signpost/2012-08-06/Op-ed)",
outlining his vision for what Wikipedia should look like.

<blockquote>
During the question-and-answer period, I was asked whether people should think of Athena as a skin, a project, or something else. I responded, "You should think of Athena as a kick in the head" – because that's exactly what it's supposed to be: a radical and bold re-examination of some of our sacred cows when it comes to the interface. 
</blockquote>

His proposal had some flaws, but it was ambitious, different and forced people to think about what the software could be like.

By 2013-2014, focus pivoted to "[Winter](https://www.mediawiki.org/wiki/Winter)", an actual prototype that people could play with and conduct user testing on. <s>Unfortunately I've been unable to find any screenshots or videos
of the prototype</s> You can [play with the original prototype](https://winter.toolforge.org/) (thanks to Izno for pointing out it has been resurrected). Jorm would leave the WMF in 2015 and it seemed like the project had effectively died.

But later in 2015, [Isarra](https://www.mediawiki.org/wiki/User:Isarra) (a volunteer, and a good friend of mine) unexpectedly dropped a mostly functional skin implementing the Winter prototype, named "Timeless". You can
[try it yourself on Wikipedia today](https://en.wikipedia.org/?useskin=timeless). (I'll wait.)

By the end of 2016, there was a request for it to be deployed to Wikimedia sites. It underwent a security review, multiple rounds of developers
poking at it, filing bugs and most importantly, fixing those bugs. The first set of French communities volunteered to test Timeless in February and March 2017. Finally in August 2017 it was deployed as an opt-in user preference to
[test.wikipedia.org](https://phabricator.wikimedia.org/T154371#3520145), then iteratively deployed to wikis that requested it in the following weeks before being enabled everywhere in November.

I've been using Timeless ever since, on both my wide monitor and tiny (relatively) phone, it works great. I regularly show it to people as a better alternative to the current mobile interface and they're usually blown away. On my
desktop, I can't imagine going back to a single-sidebar layout.

In January 2021, I interviewed Jorm for a [*Signpost* story](https://en.wikipedia.org/wiki/Wikipedia:Wikipedia_Signpost/2021-01-31/Technology_report), and asked him about Timeless. He said, "I love Timeless and it absolutely should
replace Vector. Vector is a terrible design and didn't actually solve any of the problems that it was trying to; at best it just swept them under rugs. I think the communities should switch to Timeless immediately."

## What went wrong?

At the end of 2017, following Timeless being deployed everywhere as opt-in, Isarra [applied for a grant](https://meta.wikimedia.org/wiki/Grants:Project/Isarra/Post-deployment_support) to continue supporting and developing
Timeless (I volunteered as one of the advisors). Despite overwhelming public support from community members and WMF staff, it was
[rejected for vague reasons](https://meta.wikimedia.org/wiki/Grants_talk:Project/Isarra/Post-deployment_support#Round_2_2017_decision) that I'm comfortable describing as in bad faith. Eventually she
[applied yet once again](https://meta.wikimedia.org/wiki/Grants:Project/Timeless/Post-deployment_support) and received approval midway through 2018. This time I provided some of the
"[official WMF feedback](https://meta.wikimedia.org/wiki/Grants_talk:Project/Timeless/Post-deployment_support#Feedback_from_Kunal)" publicly. But the constant delays and secret objections took a lot of steam out of the
project.

Despite all of that, people were still enthusiastic about Timeless! In March 2019, the [French Wiktionary requested Timeless to become their default skin](https://phabricator.wikimedia.org/T217883). This is a much bigger
deal than just allowing it as an opt-in choice, and led to discussion of whether Wikimedia wikis need to have a consistent brand identity, how much extra work developers would need to do to ensure they fully support the
now-two default skins, and so on. You can read the [full statement](https://phabricator.wikimedia.org/T217883#5066346) on why the task was declined - I largely don't disagree with most of it and the conclusion. If Timeless was
going to become the default, it really needed to be the default for everyone.

Of course, this principle of consistency would be [thrown out](https://en.wikipedia.org/wiki/Wikipedia:Requests_for_comment/Deployment_of_Vector_(2022)#About_this_RfC) in the 2022 English Wikipedia discussion on whether to switch
the default to the new "Vector 2022" skin, which was going to be allowed to opt-out of the interface everyone else was using if they voted against it.

Had the French Wiktionary been allowed to switch their default to Timeless, it would've continued to get more attention from users and developers, likely leading to more wikis asking for it to become the default.

You can [skim through how Vector 2022 came about](https://en.wikipedia.org/wiki/Wikipedia:Requests_for_comment/Deployment_of_Vector_(2022)/More_about_Vector_(2022)). Just imagine if even a fraction of those resources had gone
toward moving forward with Timeless, backing a volunteer-driven project. It's just sad to think of it now.

## So...

I started this story with Jorm's op-ed rather than a history of MediaWiki skins because I think he accurately captured that the skin is just a subset of the broader workflows that Wikipedians go through that desperately need
improvement. Unfortunately that focus on workflows has been lost and it shows, we're all still using the same gadgets for critical workflows that we were 10 years ago. (I won't go into detail on the various Timeless features
that make workflows easier rather than more difficult.)

Vector 2022, coming 12 years after the original Vector, is a rather narrow subset of fixes to the largest problems Vector had (lack of responsiveness, collapsed personal menu, sticky header, etc.). It's just not the bold
change we need. Timeless, far from perfect, was certainly a lot closer.
