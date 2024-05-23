Title: 2023 Wikimedia Hackathon recap
Date: 2023-05-31 23:59:59
Category: MediaWiki
Tags: mediawiki, hackathon, athens, wikimedia, greece

I had a wonderful time at the [2023 Wikimedia Hackthon](https://www.mediawiki.org/wiki/Wikimedia_Hackathon_2023) in Athens, Greece, earlier this month. The best part was easily seeing old friends that I haven't met in person since
probably 2018 and getting to hack and chat together. I also met a ton of new friends for the first time, even though we've been working together for multiple years at this point! I very much enjoy the remote, distributed nature
of working in Wikimedia Tech, but it's also really nice to meet people in person.

This post is very scattered because that was my experience at the hackathon itself, just constantly running around, bumping into people.

I wrote that I wanted to work on: "mwbot-rs and Rust things, technical governance (open to nerd sniping)". I definitely did my fair share of Rust evangelism and had good discussions regarding technical governance (more on that another
time). And some Mastodon evangelism and a bunch of sticker trading.

But before I got into hacking things, I tabulated and published the results of the [2022 Commons Picture of the Year contest](https://commons.wikimedia.org/wiki/Commons:Picture_of_the_Year/2022/Results), which I think turned out
pretty well this year. Of course, the list of things to improve for next year keeps getting longer and longer (again, more on that in a future post).

At some point during conversation, I/we realized that the GWToolset extension was still deployed on Wikimedia Commons despite being, well, basically dead. It hadn't been used in over a year and [last rites were administered back in November](https://commons.wikimedia.org/wiki/Commons:GLAMwiki_Toolset/Obituary) (literally, you have to look at the photos).

With a [thumbs-up from extension-undeploying expert Zabe](https://gerrit.wikimedia.org/r/c/operations/mediawiki-config/+/921252) (and others), I undeployed it! There was a "fun" moment when the venue WiFi dropped so the scap output
froze on my terminal, but I knew it sucessfully went through a few minutes later because of the IRC notification, phew. Anyways, RIP, end of an era.

And then Taavi [deployed the RealMe extension](https://phabricator.wikimedia.org/T324535), which allows wiki users to verify their Mastodon accounts and vice versa. But we went for dinner immediately after so Taavi wasn't even the
first one to announce it, [Raymond beat him to it](https://social.cologne/@Raymond/110396164044936279)! :-)

I spent a while rebasing [a patch to bring EventStreams output to parity with the IRC feed](https://gerrit.wikimedia.org/r/c/mediawiki/core/+/589166) that was first posted in April 2020 and got it merged (you're welcome Faidon ;)). 

One of the last things I did before leaving was an [interview about MediaWiki in the context of spinning up a new MediaWiki platform team](https://phabricator.wikimedia.org/T336990#8886706) (guess which one I am). At one point the
question was "What is the *single* biggest pain point of working in MediaWiki?" Me: "can I have two?"

Reviewed a bunch of stuff:

* [Add Authorization to default $wgAllowedCorsHeaders](https://gerrit.wikimedia.org/r/c/mediawiki/core/+/919386) - this is something 0xDeadbeef had asked for. Reedy, sitting next to us, verbally approved the security aspect, but since I had already
  packed away my laptop, I tried to +2 it from Lucas's only to discover he didn't have +2 on his volunteer account. Hence [T337014](https://phabricator.wikimedia.org/T337014). (And then I +2'd it later and Reedy did backports)
* [Define merge strategy for ContactConfig as array_plus_2d](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/ContactPage/+/869749) - me, crying about merge strategies again
* [Prepare CheckUser pagers for event table migration](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/CheckUser/+/921358), [Ensure last timestamp is shown when no matches found for an IP](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/CheckUser/+/888661) - it's nice sitting next to people because I can watch them demonstrate it working on their laptop instead of having to set it all up on mine :)
* [Add config to control default collapse state of CheckUserHelper](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/CheckUser/+/886201) - had a good discussion about avoiding (IMO) unnecessary config settings, and then I merged it :p
* [language: Annotate list() methods as preserving taintedness](https://gerrit.wikimedia.org/r/c/mediawiki/core/+/902363/)
* [Add 'preloadcontent' and 'editintro' in API prop=info](https://gerrit.wikimedia.org/r/c/mediawiki/core/+/921405) - again, nice to sit next to people who have all the test cases ready to go

Probably the most important [patch](https://gerrit.wikimedia.org/r/c/mediawiki/core/+/921530) I wrote at the hackathon was to add MaxSem, Amir (Ladsgroup), TheDJ and Petr Pchelko to the primary MediaWiki authors list on
[Special:Version](https://en.wikipedia.org/wiki/Special:Version). <3

Despite having a bunch of wonderful people being there, it was also very apparent who wasn't there. We need more regional hackathons and after a bit of reassurance from Siebrand and Maarten, it became clear that we have enough
Wikimedia Tech folks in New York City already, so uh, stay tuned for details about some future NYC-based hackathon and let me know if you're interested in helping!

Final thanks to the Wikimedia Foundation for giving me a scholarship to attend. I really can't wait until the next time I get to see everyone again.
