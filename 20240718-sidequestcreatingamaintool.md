Title: Side quest: creating a "main" tool
Date: 2024-07-18 00:57:56
Category: Tech
Tags: rust, main, git, llm, sidequest

I like Simon Willison's framing of using large language models (aka LLMs, aka "AI")
to enable [side quests](https://simonwillison.net/2024/Mar/22/claude-and-chatgpt-case-study/)
of things you wouldn't normally do.

> Could I have done this without LLM assistance? Yes, but not nearly as quickly. And this was not a task on my critical path for the day—it was a sidequest at best and honestly more of a distraction.

So, yesterday's side quest: writing a tool that checks out the
default branch of a Git repository, regardless of what it's named.

Context: most of my work these days happens on GitHub, which involves creating
PRs off the main branch, which means I'm frequently going back to it, via
`git checkout main` and then usually a `git pull` to fast-forward the branch.

But just to make things a little more interesting, the [SecureDrop server](https://github.com/freedomofpress/securedrop)
Git repository's main branch is named `develop`, which entirely screws with
muscle memory and autocomplete. Not to mention all the older projects that still use a `master` branch.

For a while now I've wanted a tool that just checks out the main branch,
regardless of what it's actually named, and optionally pulls it and stashes
pending changes.

I asked [Claude](https://claude.ai/) 3.5 Sonnet for exactly that:

> I want a Rust program named "main" that primarily checks out the main branch of a Git repository (or master if it's called that).
>
> I want to invoke it as:
>
> * `main` - just checkout the main branch
> * `main stash` - stash changes, then checkout main, then pop the stash
> * `main pull` - checkout main and then git pull
> * `main stash pull` or `main pull stash` - stash changes, checkout main, then pull, then pop the stash

It was mostly there, except it hardcoded the `main` and `master` branches
intead of looking it up via Git. I asked:

> Is there a smarter way to determine the main branch? What if it's called something other than main or master?

And it adjusted to checking `git symbolic-ref refs/remotes/origin/HEAD`, which
I didn't know about.

I cleaned up the argument handling a little bit, added `--version` and published
it on [Salsa](https://salsa.debian.org/legoktm/main).

It took me about 5-10 minutes for this whole process, which according to [xkcd](https://xkcd.com/1205/)
is an efficiency positive (saves 1 second, but I do it ~5 times a day) over 5 years.

It probably would've taken me 2-3x as long without using an LLM, but honestly,
I'm not sure I would've ever overcome the laziness to write something so small.

Anyways, so far I haven't really gotten around to writing about my experiences and feelings
about LLMs yet, so here's literally the smallest piece of work to kick that off.
