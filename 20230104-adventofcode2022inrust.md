Title: Advent of Code 2022, in Rust
Date: 2023-01-04 09:06:06
Category: Tech
Tags: advent-of-code, rust

There's a yearly programming contest called [Advent of Code](https://adventofcode.com/) (AoC).
If you haven't heard about it, I'd recommend reading [betaveros's post](https://blog.vero.site/post/advent-leaderboard) explaining what makes it unique.

This was my third attempt at AoC, previously trying it in 2019 (made it to day 5) and 2021 (day 6). This year I made it to... *drumroll* ...day 14! I had a good time this year, primarily because a group of friends (read: wiki folks on Mastodon) were doing it
every day, so I'd be motivated to be able to compare my solution with their own.

Then on day 15 at midnight I looked at the puzzle and said "nope." and went to sleep.

AoC definitely messed with my sleep schedule being on EST and starting the puzzles at midnight rather than the 9 p.m. back in PST. Once I finished each puzzle, it always took a while to calm down from the rush and by then I'm sleeping at least an hour later than I should've been.

But since I was starting as soon as the puzzle came out on most days, the leaderboard accurately reflects how long it took me on those puzzles:
<pre>
      --------Part 1---------   --------Part 2---------
Day       Time    Rank  Score       Time    Rank  Score
 14   00:35:44    2411      0   00:40:21    1977      0
 13   00:30:11    1920      0   00:38:08    1735      0
 12   23:09:41   34803      0   23:24:54   33874      0
 11   00:28:01    1435      0   01:01:03    2707      0
 10   00:15:40    2657      0   00:27:38    1841      0
  9   02:34:24   15092      0   02:56:58   11213      0
  8   00:36:38    6896      0       >24h   61768      0
  7   00:34:54    2671      0   00:45:38    2924      0
  6   00:08:31    5046      0   00:10:01    4555      0
  5   00:16:09    1720      0   00:17:34    1375      0
  4   00:08:33    3667      0   00:10:10    2539      0
  3   14:34:00   82418      0   22:00:31   92084      0
  2   14:27:16  100430      0   14:47:19   94770      0
  1   17:13:27  112294      0   17:16:09  107095      0
</pre>

Day 5 was my best performance, I attribute that to the input format requiring a more-complex-than-usual parser, which I sidestepped by cleaning up the input
in my editor first.

I posted a link to each day's solution and some commentary on a [Mastodon thread](https://wikis.world/@legoktm/109440775697576369). All of my solutions
are available in a [Git repo](https://git.legoktm.com/legoktm/advent-of-code-2022).

Overall I enjoyed doing the challenges in Rust. I feel that a good amount of the puzzles just required basic string/array manipulation, which are faster to
do in a dynamically typed language like Python, but there were plenty of times I felt Rust's match statement (which Python now sort of has...) and sum types
came in handy. Specifically with Rust's match statement, the compiler will complain if you don't satisfy some branch, which helped when e.g. implementing the [rock-paper-scissors state machine](https://git.legoktm.com/legoktm/advent-of-code-2022/src/main/src/bin/day2.rs#L77).

As far as learning goes, I picked up some CS concepts like [Dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm). I'm not sure I really learned any more Rust, just got more comfortable with the
concepts I already knew and likely faster at applying them. For the past few months I feel like I'm now thinking in Rust, rather than thinking in Python and writing it in Rust.

Past puzzles are available indefinitely, so you can do them whenever you want. I don't plan on finishing the rest, I mostly lost the incentive now that it's no longer a daily thing. But I'll probably try again in December and see
how far I go :-)
