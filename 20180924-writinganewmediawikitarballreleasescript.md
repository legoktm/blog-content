Title: Writing a new MediaWiki tarball release script
Date: 2018-09-24 06:07:35
Category: MediaWiki

Last week's security release of MediaWiki [1.27.5 / 1.29.3 / 1.30.1 / 1.31.1](https://lists.wikimedia.org/pipermail/mediawiki-announce/2018-September/000223.html) mentioned a small hint of a new release script being used for this release. [Chad](https://www.mediawiki.org/wiki/User:%F0%9F%98%82) came up with the concept/architecture of the new script, I wrote most of the code, and [Reedy](https://en.wikipedia.org/wiki/User:Reedy) did the actual release, providing feedback on missing functionality and other feature requests.

Before I explain the new script, let me explain how the old script worked ([source](https://gerrit.wikimedia.org/g/mediawiki/tools/release/+/0484cd7203224e96538a3c7367497bc15ec27a67/make-release/makerelease.py)). First, the script would clone MediaWiki core, extensions, skins, and vendor for you. Except it wanted one directory per version being released, so if you wanted to do a security release for 4 MediaWiki versions, then you'd need to have MediaWiki core cloned 4 times! Oh, but since we need to make patch files against the previous release, it'll need to recreate those tarballs (a separate problem), so you now have 8 clones of MediaWiki core. Ouch.

Then comes security patches. These patches are not yet published on Gerrit, and currently only exist as git patch files. The old script required these be in a patches directory, but in a specific naming pattern so the script would know which branch they should be applied to. Mostly this confused releasers and wasn't straightforward.

There were definitely other issues with the old script, but those two were the main motivation for me at least.

Enter makerelease2.py ([inital commit](https://gerrit.wikimedia.org/r/c/mediawiki/tools/release/+/454609)). The theory behind this script is to simply archive whatever exists in git. We added the bundled extensions and skins plus vendor as submodules, so we did not have to maintain separate configuration on which extensions should be bundled for which MediaWiki version. This also had the added benefit of making the build more reproducible, as each tag now has a pointer to specific extension commits instead of always using the tip of the release branch.

Excluded files can be maintained with [.gitattributes](https://www.git-scm.com/docs/gitattributes) rather than by the release script (yet another plus for reproducibility, maybe you can see a pattern :)).

If you're not already familiar, there's a [git-archive](https://git-scm.com/docs/git-archive) command, which creates tarballs (or zipballs) based on what is in your repository. Notably, GitHub uses this for their "Download tarball/zipball" feature.

There's only one drawback - git-archive doesn't support submodules. Luckily other people have also run into this limitation, and [Kentzo](https://github.com/Kentzo) on GitHub wrote a library for this: [git-archive-all](https://github.com/Kentzo/git-archive-all). It respects .gitattributes, and had nearly all the features we needed. It was missing the ability to unset git attributes, which I submitted [a pull request](https://github.com/Kentzo/git-archive-all/pull/45) for, and Kentzo fixed up and merged!

So, running the new script: `./makerelease2.py ~/path/to/mw-core 1.31.1`. This will spit out two tarballs, one of the `mediawiki-core` variant (no extensions or skins bundled), and the full `mediawiki` tarball. You can create a tarball of whatever you want, a tag, branch, a specific commit, etc., and it'll run. Additional checks will kick in if it is a tag, notably that it will verify that $wgVersion matches the tag you're trying to make.

To create a security release, you take a fresh clone of MediaWiki core, apply the security patches to the git tree, and create the new tags. Using the native git tools makes it straightforward to apply the patches, and then once the release has been announced, it can easily be pushed to Gerrit.

If you pass `--previous 1.31.0`, then it will additionally create a patch file against the previous tarball that you specified. However, instead of trying to recreate that tarball if it doesn't exist, we download that tarball from releases.wikimedia.org. So regardless of any changes to the release scripts, the patch file will definitely apply to the previous tarball (this wasn't true in the past).

The following bugs were fixed by this rewrite:

* [T949: update make-release to refuse to work if tag != $wgVersion](https://phabricator.wikimedia.org/T949)
* [T73379: Upgrade patches for tarball releases don't apply cleanly to tarball installation](https://phabricator.wikimedia.org/T73379)
* [T180522: Make make-release not need to clone MW for every branch](https://phabricator.wikimedia.org/T180522)
* [T180532: make-release vendor diffing broken for REL1_27/REL1_28](https://phabricator.wikimedia.org/T180532)

What's next? This was really only step 1 in the "streamline MediaWiki releases" project. The next step (as [outlined](https://phabricator.wikimedia.org/T156445#3088982) by Chad) is to continuously be generating tarballs, and then be generating secret tarballs that also include the current security patches. I don't think any of this is especially technically hard, it will mostly require process improvements with how we handle and manage security patches.
