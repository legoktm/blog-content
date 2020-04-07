Title: Fixing npm security issues immediately in MediaWiki projects
Date: 2020-04-05 08:38:05
Category: MediaWiki
Tags: mediawiki, npm, security, libup

For the past 5ish years, I've been working on a project called [libraryupgrader](https://www.mediawiki.org/wiki/Libraryupgrader) (LibUp for short) to semi-automatically upgrade dependency libraries in the 900+ MediaWiki extension and related git repositories. For those that use GitHub, it's similar to the new dependabot tool, except LibUp is free software.

One cool feature that I want to highlight is how we are able to fix npm security issues in generally under 24 hours across all repositories with little to no human intervention. The first time this feature came into use was to roll out the [eslint RCE fix](https://eslint.org/blog/2019/08/eslint-v6.2.1-released) ([example commit](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/PageImages/+/531750)).

This functionality is all built around the [npm audit](https://docs.npmjs.com/cli/audit) command that was [introduced in npm 6](https://blog.npmjs.org/post/173719309445/npm-audit-identify-and-fix-insecure). It has a JSON output mode, which made it straightforward to create a [npm vulnerability dashboard](https://libraryupgrader2.wmflabs.org/vulns/npm) for all of the repositories we track.

The magic happens in the `npm audit fix` command, which automatically updates semver-safe changes. The one thing I'm not super happy about is that we're basically blindly trusting the response given to us by the npm server, but I'm not aware of any free software alternative.

LibUp then writes a commit message by mostly analyzing the diff, fixes up some changes since we tend to pin dependencies and then pushes the commit to Gerrit to pass through CI and be merged. If npm is aware of the CVE ID for the security update, that will also be mentioned in the commit message ([example](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/527822)). In addition, each package upgrade is tagged, so if you want to e.g. look for all commits that bumped MediaWiki Codesniffer to v26, it's a [quick search](https://gerrit.wikimedia.org/r/q/hashtag:%22c%253Bmediawiki%252Fmediawiki-codesniffer%253D26.0.0%22+(status:open%20OR%20status:merged)) away.

Lately LibUp has been occupied fixing the [minimist prototype pollution advisory](https://www.npmjs.com/advisories/1179) through a bunch of dependencies: gonzales-pe, grunt, mkdirp and postcss-sass. It's a rather low priority security issue, but it now requires very little human attention because it has been automated away.

There are some potential risks - someone could install a backdoor by putting an intentional vulnerability in the same version as fixing a known/published security issue. LibUp would then automatically roll out the new version, making us more vulnerable to the backdoor. This is definitely a risk, but I think our strategy of pulling in new security fixes automatically protects us more than the potential downside of malicious actors abusing the system (also because I wouldn't absolutely trust any code pulled down from npm in the first place!).

There are some errors we see occasionally, and could use help resolving them: [T228173](https://phabricator.wikimedia.org/T228173) and [T242703](https://phabricator.wikimedia.org/T242703) are the two most pressing ones right now.


