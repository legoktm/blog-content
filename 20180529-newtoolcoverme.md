Title: Introducing CoverMe: find the most called MediaWiki code lacking test coverage
Date: 2018-05-29 04:57:10
Category: MediaWiki
Tags: mediawiki, coverage, toolforge

<center>[CoverMe](https://tools.wmflabs.org/coverme/), hosted on Wikimedia Toolforge</center>

Test coverage is a useful metric, but it can be difficult to figure out exactly where to start. That's where CoverMe is useful - it sorts functions by how often they're called on Wikimedia production servers, and then displays their coverage status.

![CoverMe]({filename}/images/Screenshot-2018-5-28_CoverMe.png)

[Try it out](https://tools.wmflabs.org/coverme/)! You can filter by Git repository and entry point (index.php, load.php, etc.). So if you look at the [api.php entry point](https://tools.wmflabs.org/coverme/?repo=MediaWiki+core&type=api), you'll see mostly API related code. If I look at the [Linter extension](https://tools.wmflabs.org/coverme/?repo=Extension%3ALinter&type=all), I can see that the `RecordLintJob::run` is well covered, while `ApiRecordLint::run` is not covered at all. If some extensions simply aren't called that frequently, there might not be any function call data at all.

The function call data comes from the daily [Xenon logs](https://performance.wikimedia.org/xenon/logs/daily/) that are used for profiling FlameGraphs, and the [CI test coverage data](https://doc.wikimedia.org/cover-extensions/). CoverMe fetches updated data on the hour if it's available.

The source code is [published on Phabricator](https://phabricator.wikimedia.org/source/tool-coverme/) and licensed under the AGPL v3, or any later version.
