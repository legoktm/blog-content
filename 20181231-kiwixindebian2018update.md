Title: Kiwix in Debian, 2018 update
Date: 2018-12-31 03:44:02
Category: Tech
Tags: debian, kiwix, stickers

It's been a relatively productive year for the packaging of [Kiwix](https://www.kiwix.org/), an offline Wikipedia reader, in Debian. My minimum expectations for the Buster release scheduled in mid-2019 are that all necessary C/C++ libraries to build the latest versions of Kiwix are in Debian.

* [libzim](https://tracker.debian.org/pkg/zimlib) is at v4.0.4, and basically ready to go.
* [libkiwix](https://tracker.debian.org/pkg/libkiwix) is prepared for v3.0.3, but is waiting on the FTP masters to approve the new version that is in the [NEW queue](https://ftp-master.debian.org/new.html) (fifth oldest binary-NEW package as of this post...). Once that is approved, I have the v3.1.1 upgrade prepared as well.
* [ctpp2](https://tracker.debian.org/pkg/ctpp2) was a bit of a struggle, but is ready to go as well. However, it looks like the upstream website has vanished (it was inactive for years), so it's good that Kiwix is planning to [replace ctpp2](https://github.com/kiwix/kiwix-lib/issues/21) in the future.

There are three main user facing packages that are in the pipeline right now:

* [zimwriterfs](https://github.com/openzim/zimwriterfs) is waiting in the NEW queue. I'm hopeful that we can get this included in time for Debian Buster.
* [kiwix-tools](https://github.com/kiwix/kiwix-tools) is a bundle of command-line utilities, the most useful of which is kiwix-serve. There's one [upstream issue](https://github.com/kiwix/kiwix-tools/issues/249) relating to how JavaScript code is embedded, but the packaging prep work is [basically done](https://salsa.debian.org/legoktm/kiwix-tools). It's blocked on the new libkiwix anyways.
* [kiwix-desktop](https://github.com/kiwix/kiwix-desktop) or just "Kiwix" is the most interesting thing for typical users who want to read offline content, but it's probably the farthest away. I spent some time this week figuring out how to get it to compile, and mostly [got it to work](https://github.com/kiwix/kiwix-desktop/issues/90). Probably something to aim for the next Debian release. There's also work underway to [provide it as a flatpak](https://github.com/flathub/flathub/pull/768), which will benefit even more people.

I also created a "[Kiwix team](https://tracker.debian.org/teams/kiwix-team/)" in the Debian Package Tracker, so you can subscribe to different notifications for all of the Kiwix-related packages (though it might be spammy if you're not very interested in Debian internals).

And, thank you to the Kiwix developers for always being receptive to my bug reports and patches - and providing extra chocolate and stickers :-)

![Gifts]({static}/images/kiwix.jpg)
