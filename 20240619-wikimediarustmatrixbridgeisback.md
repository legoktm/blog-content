Title: #wikimedia-rust Matrix to IRC bridge is back
Date: 2024-06-19 20:11:08
Category: MediaWiki
Tags: rust, matrix, irc, libera, mwbot

tl;dr: You can now chat in [`#wikimedia-rust:matrix.org`](https://matrix.to/#/#wikimedia-rust:matrix.org) and reach folks on IRC

Nearly a year ago, the official Libera.Chat <-> Matrix bridge was [shut down](https://libera.chat/news/matrix-bridge-disabled-retrospective).
There's a lot that went wrong in the technical and social operation of the bridge
that the Libera.Chat staff have helpfully documented, but from a community management perspective
the bridge, when it worked, was fantastic.

But, we now have a bridge back in place! [Bridgebot](https://wikitech.wikimedia.org/wiki/Tool:Bridgebot) is a deployment of
[matterbridge](https://github.com/42wim/matterbridge), which is primarily used in Wikimedia spaces for bridging IRC and Telegram, but it also
speaks Matrix reasonably well.

Thanks to Bryan Davis for starting/maintaining the bridgebot project and Lucas Werkmeister
for deploying the change; we now have a bot that relays comments between IRC and Matrix.

```irc
12:12:50 <wm-bb> [matrix] <legoktm> ooh, I think the Matrix bridging is working now
12:12:58 <legoktm> o/
```

And if you look at the [view.matrix.org logs](https://view.matrix.org/alias/%23wikimedia-rust:matrix.org), those messages are there too.

So if you're interested in or working on Wikimedia-related things that are in
Rust, please join us, in either IRC or Matrix or both :)
