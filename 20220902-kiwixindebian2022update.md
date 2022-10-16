Title: Kiwix in Debian, 2022 update
Date: 2022-09-02 03:06:58
Category: MediaWiki
Tags: kiwix, debian, offline, wikipedia

*Previous updates: [2018](https://blog.legoktm.com/2018/12/31/kiwix-in-debian-2018-update.html), [2021](https://blog.legoktm.com/2021/08/19/kiwix-returns-in-debian-bullseye.html)*

[Kiwix](https://www.kiwix.org/en/) is an offline content reader, best known
for distributing copies of Wikipedia. I have been maintaining it in Debian
since 2017.

This year most of the work has been keeping all the packages up to date in anticipation of next year's Debian 12 Bookworm release,
including several [transitions](https://wiki.debian.org/Teams/ReleaseTeam/Transitions)
for new libzim and libkiwix versions.

* libzim: 6.3.0 → 8.0.0
* zim-tools: 2.1.0 → 3.1.1
* python-libzim: 0.0.3 → 1.1.1 (with a [cherry-picked patch](https://github.com/openzim/python-libzim/pull/151))
* libkiwix: 9.4.1 → 11.0.0 (with [DFSG](https://www.debian.org/social_contract#guidelines) issues fixed!)
* kiwix-tools: 3.1.2 → 3.3.0
* kiwix (desktop): 2.0.5 → 2.2.2

The [Debian Package Tracker](https://tracker.debian.org/teams/kiwix-team/)
makes it really easy to keep an eye on all Kiwix-related packages.

All of the "user-facing" packages (zim-tools, kiwix-tools, kiwix) now have
very basic [autopkgtests](https://ci.debian.net/doc/) that can provide a
bit of confidence that the package isn't totally broken. I recommend reading
the "[FAQ for package maintainers](https://ci.debian.net/doc/file.MAINTAINERS.html)"
to learn about all the benefits you get from having autopkgtests.

Finally, back in March I wrote a blog post, [How to mirror the Russian Wikipedia with Debian and Kiwix](https://blog.legoktm.com/2022/03/15/how-to-mirror-the-russian-wikipedia-with-debian-and-kiwix.html),
which got significant readership (compared to most posts on this blog), including
being quoted by [LWN](https://lwn.net/Articles/902463/)!

We are always looking for more contributors, please reach out if you're
interested. The Kiwix team is one of my favorite groups of people to work
with and they love Debian too.
