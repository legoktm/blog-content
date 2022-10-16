Title: Kiwix returns in Debian Bullseye
Date: 2021-08-19 03:41:45
Category: MediaWiki
Tags: debian, kiwix, offline, wikimedia

(This is my belated #newindebianbullseye post.)

The latest version of the Debian distro, 11.0 aka Bullseye, was [released last week](https://www.debian.org/News/2021/20210814) and after a long absence, includes [Kiwix](https://www.kiwix.org/)! Previously in Debian 10/Buster, we only had the [underlying C/C++ libraries available](https://blog.legoktm.com/2018/12/31/kiwix-in-debian-2018-update.html).

If you're not familiar with it, Kiwix is an offline content reader, providing Wikipedia, Gutenberg, TED talks, and more in ZIM (`.zim`) files that can be [downloaded and viewed entirely offline](https://wiki.kiwix.org/wiki/Content_in_all_languages). You can get the entire text of the English Wikipedia in less than 100GB.

`apt install kiwix` will get you a graphical desktop application that allows you to download and read ZIMs. `apt install kiwix-tools` installs `kiwix-serve` (among others), which serves ZIM files over an HTTP server.

Additionally, there are now tools in Debian that allow you to create your own ZIM files: `zimwriterfs` and the `python3-libzim` library.

All of this would not have been possible without the support of the Kiwix developers, who made it a priority to properly support Debian. All of the Kiwix and repositories have a [CI process](https://wiki.kiwix.org/wiki/Ubuntu_PPA/FAQ) that builds Debian packages for each pull request and needs to pass before it'll be accepted.

Ubuntu users can take advantage of [our primary PPA](https://launchpad.net/~kiwixteam/+archive/ubuntu/release) or the [bleeding-edge PPA](https://launchpad.net/~kiwixteam/+archive/ubuntu/dev/). For Debian users, my goal is that unstable/sid will have the latest verison within a few days of a release, and once it moves into testing, it'll be available in [Debian Backports](https://backports.debian.org/).

It is always a pleasure working with the Kiwix team, who make a point to [send stickers and chocolate every year](https://legoktm.com/w/images/b/bc/Kiwix_stickers_and_chocolate_%282020%29.jpg) :)
