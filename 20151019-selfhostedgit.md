Title: Self-hosted git
Date: 2015-10-19 07:34
Category: Tech
Tags: freedom, git, gogs

As part of using only free software, I also started thinking about the various non-free services I am dependent upon. One of those I had already started working on replacing was Github. Github is currently the canonical source location for a lot of my various projects, including some that aren't even on my laptops.

So, alternatives. First I considered a hosted service that runs free software, but those don't really exist any more. [Gitorious](https://gitorious.org/) has shut down, and it turns out that [GitLab](https://about.gitlab.com/) has gone [open core](https://lists.wikimedia.org/pipermail/wikitech-l/2015-October/083506.html).

Alright then, self-hosted git it is. I tried out and evaluated two projects: cgit and gogs.

[cgit](http://git.zx2c4.com/cgit/) is a web viewer for git repositories written in C. I like the UI, having used it while browsing Fedora and Linux kernel repositories. The basic set up of it was pretty simple, I downloaded and unzipped it, set up some Apache CGI rules, and bam, it was running. I imported 2 git repositories, and they showed up right away. I started trying to enable some other features like syntax highlighting, and that's where it stopped being easy to work with. I tried both Pygments and a Perl highlighter, neither worked. Around this point I got bored and gave up.

[gogs](http://gogs.io/) is a full blown clone of Github's features written in Go. The UI is extremely similar to Github, so it was very easy to figure out. Set up was a little tricky, I had to create a "git" user for it to run as, and then fiddle with setting up an Apache proxy rule so <code>/git</code> proxies to localhost:3000 (I originally started out in a sub-path instead of a full sub-domain). After that, I was able to import a few Github repos directly, and clone them. Yay! It also has a mirror feature that can synchronize with an external repository every hour. I found a [gogs-migrate](https://github.com/valeriangalliat/gogs-migrate) tool that claimed to set up mirrors of all your Github repos in a gogs installation, but I couldn't get it to work. I ended up writing my own Python version called [gogs-mirror](http://git.legoktm.com/legoktm/gogs-mirror). And for bonus points, I submitted an [upstream pull request](https://github.com/gogits/gogs/pull/1799) to improve an interface message.

Currently I have gogs running at [git.legoktm.com](http://git.legoktm.com/). All of my non-forked Github repos are mirrored there, and it also is the canonical source of gogs-mirror. The next step will be to switch the mirroring, so that the canonical source lives on git.legoktm.com, and Github is a mirror. I'll also want to update links to those repositories on places like PyPI, various wikis, etc. More to come!
