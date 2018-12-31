Title: MediaWiki - powered by Debian
Date: 2017-01-16 10:18
Category: MediaWiki
Tags: mediawiki, debian

Barring any bugs, the last set of changes to the MediaWiki Debian package for the stretch release landed earlier this month. There are some documentation changes, and updates for changes to other, related packages. One of the other changes is the addition of a "powered by Debian" footer icon (drawn by the amazing [Isarra](https://www.mediawiki.org/wiki/User:Isarra)), right next to the default "powered by MediaWiki" one.

![Powered by Debian]({filename}/images/poweredby_debian_2x.png)

This will only be added by default to new installs of the MediaWiki package. But existing users can just copy the following code snippet into their <code>LocalSettings.php</code> file (adjust paths as necessary):

<pre>
# Add a "powered by Debian" footer icon
$wgFooterIcons['poweredby']['debian'] = [
	"src" => "/mediawiki/resources/assets/debian/poweredby_debian_1x.png",
	"url" => "https://www.debian.org/",
	"alt" => "Powered by Debian",
	"srcset" =>
		"/mediawiki/resources/assets/debian/poweredby_debian_1_5x.png 1.5x, " .
		"/mediawiki/resources/assets/debian/poweredby_debian_2x.png 2x",
];
</pre>

The image files are included in the package itself, or you can grab them from the [Git repository](https://phabricator.wikimedia.org/diffusion/MDEB/browse/master/debian/images/). The source SVG is available from [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Powered_by_Debian.svg).
