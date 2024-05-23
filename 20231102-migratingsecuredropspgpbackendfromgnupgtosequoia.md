Title: Migrating SecureDrop’s PGP backend from GnuPG to Sequoia
Date: 2023-11-02 03:17:18
Category: SecureDrop
Tags: securedrop, rust, openpgp, gpg, sequoia

I haven't been very good with writing about what I've been working on in SecureDrop-land, but here is: [Migrating SecureDrop’s PGP backend from GnuPG to Sequoia](https://securedrop.org/news/migrating-securedrops-pgp-backend-from-gnupg-to-sequoia/)
over on the SecureDrop website. You should read it, and then come back to read the rest of this.

We had been discussing Sequoia internally for a while, but I officially filed an issue titled "[Use Sequoia-PGP instead of gpg/pretty_bad_protocol](https://github.com/freedomofpress/securedrop/issues/6399)" in April 2022. I pushed
a first WIP of the Rust code to a branch named `oxidize` on July 8, 2022 and had it working in the development environment by the 14th. TBH that was the easy part, migrating existing sources from GPG to Sequoia was going to be 
the hard part.

Small tangent, I was very fortunate to grow up around a lot of Sequoia trees, and I have very fond memories of visiting [Muir Woods National Monument](https://en.wikipedia.org/wiki/Muir_Woods_National_Monument) as a kid. So when I had
to pick a name for the Rust crate, I tried to stay with the theme, and went to the Wikipedia disambiguation page for [Sequoia](https://en.wikipedia.org/wiki/Sequoia), clicked on the first link, [Sequoioideae](https://en.wikipedia.org/wiki/Sequoioideae),
read "...commonly referred to as *redwoods*", and then immediately ran `cargo new redwood --lib`. I anticipated we'd switch to a generic, boring, name like `rust` but that didn't end up happening :-).

Exporting public keys is pretty easy, but GPG stores secret keys in its own custom s-expression thing (documented as "...easier to read and edit by human beings", okay.), which we would have to write something
custom to read. I flailed around trying to do so but never really got anywhere. Sequoia opened a ticket on their end for supporting GPG's format, but as of this writing, it hasn't seen any real progress (which is fine and understandable!).

Also I got busy with other SecureDrop things (e.g. "[Reorganize Debian packaging, have debhelper do most of the work](https://github.com/freedomofpress/securedrop/pull/6544)", which deserves its own blog post).

At the end of December 2022, Sequoia announced their [chameleon](https://sequoia-pgp.org/blog/2022/12/19/202212-chameleon-0.1/) project to replace the `gpg` CLI. In January 2023 (this year!) I discussed whether using that was an
option in the Sequoia IRC channel, and Neal (who is fantastic), suggested just using GPG directly. Great idea!

Now that we had a real migration plan, February and March had some internal discussions on whether to move forward with this, and I started working on it for real in May. The [first PR](https://github.com/freedomofpress/securedrop/pull/6828) 
was up by the end of May and landed the first week of June.

The [second major PR](https://github.com/freedomofpress/securedrop/pull/6892) was posted mid-July and merged at the beginning of October! There were a number of smaller
PRs in the middle, but that was "step 2" in my high-level roadmap.
There was a lot of good back and forth during review from SecureDrop team members, Sequoia developers and other volunteer contributors. And related PRs from other SecureDrop team members.

Everything else landed in October, and then this week I finished running some benchmarking, which, surprise surprise, [showed](https://github.com/freedomofpress/securedrop/issues/7022#issuecomment-1788012330) that calling the Sequoia Rust code was faster than 
shelling out to GPG.

SecureDrop 2.7.0 powered by Sequoia should be (*knocks on wood*) released in a few days, which will be the largest milestone to date of this multi-year project. And as the blog post pointed out, there's still a lot of work to do.

This is the first Rust project that I've worked on that is being shipped to production users (all the wiki bots I've written really don't count), and it's been a blast. It certainly won't be the last ;-)

