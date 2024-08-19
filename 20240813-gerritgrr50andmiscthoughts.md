Title: gerrit-grr 5.0
Date: 2024-08-19 00:00:00
Category: MediaWiki
Tags: rust, mediawiki, gerrit, release

I recently released 5.0.0 of my [`grr` tool](https://gitlab.com/legoktm/rust-grr) that makes working
with Gerrit easier. It is an alternative to [`git-review`](https://pypi.org/project/git-review/);
I personally think `grr` is more straightforward to use, but I also haven't used `git-review` since 2014 when I first got frustrated enough to create `grr`.

I had let it bitrot since I wasn't doing as much code review and it seemed like Wikimedia
was going to [move away from Gerrit](https://www.mediawiki.org/wiki/GitLab/Migration_status) but both
of those have changed now!

There's no user-facing changes, it was just a lot of internal refactoring
that required breaking API changes, and then removing that API entirely because it was blocking further
refactoring. Rewriting `grr` in Rust was one of my [first Rust projects](/2020/06/14/learning-rust-week-2.html) and the code really showed that. It's now cleaned up and I also dropped all the dependencies that linked to C code (OpenSSL/libgit2) to make builds
easier and more portable.

Fundamentally, `grr` is a small wrapper around Gerrit's native functionality. I don't think it's widely known that submitting a patch to Gerrit is as straightforward as `git push origin HEAD:refs/for/<branch>`. And if you want to set a custom topic, you can append `%topic=<...>`.

So that's exactly what `grr` executes; but much shorter. To submit a patch just run: `grr`. (If you need to push to the non-primary branch, use `grr <branch>`.) And to pull down a patch for review, run `grr fetch <id>`. There's some more commands [documented in the README](https://gitlab.com/legoktm/rust-grr#usage).

Going back to the `%topic=` example, `grr` provides a `--topic <...>` option that turns into that. If you want to immediately set a Code-Review +2 vote when uploading (e.g. to automatically trigger CI
to merge), you can provide `--code-review=+2` (turns into `%l=Code-Review+2`).

To install, run `cargo install --locked gerrit-grr`. [Pre-built binaries](https://gitlab.com/legoktm/rust-grr/-/releases) and an [OCI image](https://gitlab.com/legoktm/rust-grr#grr) are also available.
