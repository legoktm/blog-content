Title: New tool: Wikimedia APT browser
Date: 2018-05-02 20:24:14
Category: MediaWiki
Tags: debian, mediawiki

I've created a new tool to make it easier for humans to browse Wikimedia's APT repository: [apt.wikimedia.org](https://apt.wikimedia.org). Wikimedia's servers run Debian (Ubuntu is nearly phased out), and for the most part use the standard packages that Debian provides. But in some cases we use software that isn't in the official Debian repositories, and distribute it via our own APT repository.

For a while now I've been working on different things where it's helpful for me to be able to see which packages are provided for each Debian version. I was unable to find any existing, reusable HTML browsers for APT repositories (most people seem to use the commandline tools), so I quickly wrote my own.

Introducing the [Wikimedia APT browser](https://tools.wmflabs.org/apt-browser/). It's a short (less than 100 lines) Python and Flask application that reads from the Package/Release files that APT uses, and presents them in a simple HTML page. You can see the different versions of Debian and Ubuntu that are supported, the different sections in each one, and then the packages and their versions. 

There's nothing really Wikimedia-specific about this, it would be trivial to remove the Wikimedia branding and turn it into something general if people are interested.

The source code is [published on Phabricator](https://phabricator.wikimedia.org/source/tool-apt-browser/) and licensed under the AGPL v3, or any later version.

