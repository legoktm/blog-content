Title: Basic anti-abuse monitoring for Mastodon
Date: 2024-06-26 00:12:52
Category: Tech
Tags: mastodon, fediverse, wikisworld

Back in February, Mastodon and the connected Fediverse faced a [spam attack](https://tedium.co/2024/02/20/mastodon-spam-maintenance-problem/)
caused by unattended instances with an open signup policy. Bots quickly registered
accounts and then sent spammy messages that were relayed through the Fediverse.

It was annoying and the normal moderation tool of limiting or blocking entire instances wasn't effective since the attackers were coming from a wide set of places. Since then people have developed
shared blocklists that you can subscribe to, but that has its own downsides.

So here's the tool I developed that we used for wikis.world: [masto-monitor](https://gitlab.wikimedia.org/legoktm/masto-monitor).

The workflow is straightfoward:

* Poll the federated timeline for all public posts
* Check them against a manually curated list of patterns
* If there's a match, report it using the API

This allows us to have an automated process checking all incoming posts while still enabling
humans to make any moderation decisions.

The code itself is pretty straightforward that it doesn't really merit much explanation. The matching logic is very very basic, it just looks for substring matches. I think the approach is worth developing further, allowing people to write more expressive rules/filters that trigger automated reports.

But, I'm not planning to do so myself since we don't currently have a need, so people are welcome to fork it to enhance it.
