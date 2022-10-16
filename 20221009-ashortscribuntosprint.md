Title: A short Scribunto sprint
Date: 2022-10-09 14:43:53
Category: MediaWiki
Tags: mediawiki, scribunto, lua

I recently did a short sprint on [Scribunto](https://www.mediawiki.org/wiki/Extension:Scribunto), the MediaWiki extension that powers templates written in Lua. It's a very stable extension that doesn't see very many changes
but given how useful it is to making most wikis work, I thought it could use some love.

Patches written:

* [Simplify creating JSON pages in the Module namespace](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/833989) ([T144475](https://phabricator.wikimedia.org/T144475)), "Module:Foo.json" will now automatically
  be treated as a JSON page rather than Lua.
* [Add mw.loadJsonData()](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/833990) ([T217500](https://phabricator.wikimedia.org/T217500)), optimizes the loading of JSON data. This should make it
  easier for module authors to store data separately since it doesn't need to be written in Lua tables anymore.
* [Add strict.lua to replace "Module:No globals"](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/834623) ([T209310](https://phabricator.wikimedia.org/T209310)), makes the Lua extra "strict.lua"
  available to module authors as a way of making sure all variables are properly scoped and not accidentally used in the global scope. There's already an on-wiki "Module:No globals" that does this, and it's used across 32% of
  pages on the English Wikipedia, so it'll be a nice small performance improvement too.
* [Require CSRF token for action=scribunto-console](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/836962) ([T212071](https://phabricator.wikimedia.org/T212071)), very small security hardening change for an
  internal API module.
* [Restore padding on #mw-scribunto-input to make cursor visible](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/839039) ([T272678](https://phabricator.wikimedia.org/T272678)), makes the cursor in the debug
  console visible in Chromium-based browsers. It looks slightly less like a terminal now, but more usable.
* [Hide mw.hash.setupInterface from users](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/839035) ([T276138](https://phabricator.wikimedia.org/T276138)), small cleanup, part of the boilerplate was missed to
  hide this function from users.
* [Use OOUI instead of jquery.ui for error popup](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/838283) ([T319361](https://phabricator.wikimedia.org/T319361)), get rid of some technical debt by using our
  OOUI widget library to display the error stacktrace to users instead of jquery.ui.

Revived patches:

* [Add redirects for modules](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/574086) ([T120794](https://phabricator.wikimedia.org/T120794)) by DannyS712 in 2020, rebased, adjusted formatting of the redirect and improved
  the test case so it would actually fail if the code was buggy.
* [Include the bad timestamp string in the error when unable to parse it](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/223888) by Jackmcbarn in 2015, rebased and added quotes around the error.

Reviewed patches:

* ["Namespace LuaCommon" take 2](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/820118) by Reedy
* [Capitalise Engines folder](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/818581) by Reedy
* [Namespace tests](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/818583) by Reedy
* [Apply some minor PHP code modernizations](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/836228) by Thiemo Kreuz (WMDE)
* [Make sure that lua stack trace is valid UTF-8.](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/838226) ([T319218](https://phabricator.wikimedia.org/T319218)) by Brian Wolff
* [Add more @covers](https://gerrit.wikimedia.org/r/c/mediawiki/extensions/Scribunto/+/840335) ([T320330](https://phabricator.wikimedia.org/T320330)) by Reedy

Bug triage and review:

* [T308796: Lua error: Not enough memory due to several templates in pages](https://phabricator.wikimedia.org/T308796): closed as invalid, gave guidance on where else to ask for help.
* [T289404: MediaWiki:Scribunto-doc-page-header does not propagate categories](https://phabricator.wikimedia.org/T289404): declined.
* [T240678: mw.title.new('#') returns object that errors when expensive data is accessed](https://phabricator.wikimedia.org/T240678): analyzed cause of bug and possible ways to fix it, needs more investigation on impact of such
  a change.
* [T306735: Allow mw.text.listToText() to produce a list with serial commas](https://phabricator.wikimedia.org/T306735): asked a question to better understand the use case.
* [T316035: frame:preprocess does not parse subst](https://phabricator.wikimedia.org/T316035): declined.
* [T310306: Add two hooks to Scribunto so that Module pages can be changed based on a "branch" parameter set in an invoke](https://phabricator.wikimedia.org/T310306): commented, seems out of place with our current strategy of using
  TemplateSandbox.
* [T88797: #iferror should suppress scribunto error tracking category too](https://phabricator.wikimedia.org/T88797): declined and documented the limitation.
* [T316533: Trigger category from Lua code or as parser function](https://phabricator.wikimedia.org/T316533): asked a question to better understand the use case.
* [T217508: Make CodeEditor available in modules that are subpages of a user page](https://phabricator.wikimedia.org/T217508): declined.
* [T289136: Lua debugging console doesn't output any text](https://phabricator.wikimedia.org/T289136): closed as invalid, misunderstanding of how the debug console is supposed to work.
* [T225227: gsub error emitted by mw.text.trim()](https://phabricator.wikimedia.org/T225227): declined.

This was definitely fun and has given me some ideas of other improvements that can be made. But I'm most likely going to switch focus to something else that needs some love.
