Title: texvc back in Debian
Date: 2016-12-23 06:11
Category: MediaWiki
Tags: mediawiki, debian, texvc

Today [texvc](https://www.mediawiki.org/wiki/Texvc) was re-accepted for inclusion into Debian. texvc is a TeX validator and converter than can be used with the Math extension to generate PNGs of math equations. It had been removed from Jessie when MediaWiki itself was removed. However, a texvc package is still useful for those who aren't using the MediaWiki Debian package, since it requires OCaml to build from source, which can be pretty difficult.

Pending no other issues, texvc will be included in Debian Stretch. I am also working on having it included in jessie-backports for users still on Jessie.

And as always, thanks to Moritz for reviewing and sponsoring the package!
