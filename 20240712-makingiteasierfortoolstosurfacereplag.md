Title: Making it easier for Toolforge tools to surface replag
Date: 2024-07-12 04:34:04
Category: MediaWiki
Tags: toolforge, replag, mysql, rust

A number of tools hosted on Toolforge rely on the replicated MediaWiki databases,
dubbed ["Wiki Replicas"](https://wikitech.wikimedia.org/wiki/Help:Wiki_Replicas).

Every so often these servers have [replication lag](https://en.wikipedia.org/wiki/Wikipedia:Replication_lag), which affects the data
returned as well as the performance of the queries. And when this happens,
users get confused and start reporting bugs that aren't solvable.

This actually used to be way worse during the Toolserver era (sometimes replag would be on the scale of months!), and users were
well educated to the potential problems. Most tools would display a banner if
there was lag and there were even bots that would update an [on-wiki template](https://en.wikipedia.org/w/index.php?title=Wikipedia:Toolserver/status&diff=prev&oldid=613794158)
every hour.

A lot of these practices have been lost since the move to Toolforge since
replag has been basically zero the whole time. Now that more database
maintenance is happening (yay), replag is happening slightly more often.

So to make it easier for tool authors to display replag status to users
with a minimal amount of effort, I've developed a new tool:
[replag-embed.toolforge.org](https://replag-embed.toolforge.org/demo)

It provides an iframe that automatically displays a small banner if there's
more than 30 seconds of lag and nothing otherwise.

As an example, as I write this, the current replag for commons.wikimedia.org looks like:

<style>
    .replag-lagged {
        padding: 0.5em;
        border: double #f33;
        background-color: #fee;
        margin-bottom: 1em;
    }
</style>
<p class="replag-lagged">
The replica database (s4) is currently lagged by 1762.9987 seconds (00:29:22), you may see outdated results
or slowness. See the <a href="https://replag.toolforge.org/" target="_blank">replag tool</a> for more details.
</p>

Of course, you can use CSS to style it differently if you'd like.

I've integrated this into my [Wiki streaks](https://streaks.toolforge.org/) tool, where the banner appears/disappears depending on what wiki you select and whether it's lagged.
The actual code required to do this was [pretty simple](https://gitlab.wikimedia.org/toolforge-repos/streaks/-/commit/e3f96926ada74fa33cef04716f38042ef7446b82).

replag-embed is written in Rust of course, ([source code](https://gitlab.wikimedia.org/toolforge-repos/replag-embed/)) and leverages in-memory
caching to quickly serve responses.

Currently I'd consider this tool to be beta quality - I think it is promising
and ready for other people to give it a try, but know there are probably some
kinks that need to be worked out. 

The Phabricator task tracking this work is
[T321640](https://phabricator.wikimedia.org/T321640); comments there would be
appreciated if you try it out.
