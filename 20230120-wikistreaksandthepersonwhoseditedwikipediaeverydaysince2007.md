Title: Wiki streaks, and the person who's edited Wikipedia every day since 2007
Date: 2023-01-20 08:00:00
Category: MediaWiki
Tags: wikipedia, wikistreak, toolforge, rust

This past weekend at [Wikipedia Day](https://en.wikipedia.org/wiki/Wikipedia:Meetup/NYC/Wikipedia_Day_2023) I had a discussion with [Enterprisey](https://en.wikipedia.org/wiki/User:Enterprisey) and some other folks about different
ways edit counters (more on that in a different blog post) could visualize edits, and one of the things that came up was GitHub's scorecard and streaks. Then I saw a [post from Jan Ainali](https://social.coop/@ainali/109701071799625430)
with a SQL query showing the people who had made an edit for every single day of 2022 to Wikidata. That got me thinking, why stop at 1 year? Why not try to find out the longest active editing streak on Wikipedia?

Slight sidebar, I find streaks fascinating. They require a level of commitment, dedication, and a good amount of luck! And unlike sports where if you set a record, it sticks, wikis are constantly changing. If you make an
edit, and months or years later the article gets deleted, your streak is retroactively broken. Streaks have become a part of wiki culture, with initatives like [100wikidays](https://meta.wikimedia.org/wiki/100wikidays), where people
commit to creating a new article every day, for 100 days. There's a new initiative called [365 climate edits](https://meta.wikimedia.org/wiki/Wikimedians_for_Sustainable_Development/365_climate_edits), I'm sure you can figure out
the concept. Streaks can become unhealthy, so this all should be taken in good fun.

So... I adopted Jan's query to find users who had made one edit per day in the past 365 days, and then for each user, go backwards day-by-day to see when they missed an edit. The results are...unbelievable.

[Johnny Au](https://en.wikipedia.org/wiki/User:Johnny_Au) has made at least one edit every day since November 11, 2007! That's 15 years, 2 months, 9 days and counting. Au was profiled [in the Toronto Star](https://www.thestar.com/news/gta/2015/10/12/meet-the-man-keeping-the-jays-reputation-intact-on-wikipedia.html)
in 2015 for his work on the Toronto Blue Jays' page:
<blockquote>
Au, 25, has the rare distinction of being the top editor for the Jays’ Wikipedia page. Though anyone can edit Wikipedia, few choose to do it as often, or regularly, as Au.
<br><br>
The edits are logged on the website but hidden from most readers. Au said he doesn’t want or need attention for his work.
<br><br>
“I prefer to be anonymous, doing things under the radar,” he said.
<br><br>
Au spends an average 10 to 14 hours a week ensuring the Blues Jays and other Toronto-focused Wikipedia entries are up to date and error-free. He’s made 492 edits to the Blue Jays page since he started in 2007, putting him squarely in the number one spot for most edits, and far beyond the second-placed editor, who has made 230 edits. 
<br><br>
...
<br><br>
Au usually leaves big edits to other editors. Instead, he usually focuses on small things, like spelling and style errors.
<br><br>
“I’m more of a gatekeeper, doing the maintenance stuff,” he said. 
</blockquote>

Next, [Bruce1ee](https://en.wikipedia.org/wiki/User:Bruce1ee) (unrelated to [Bruce Lee](https://en.wikipedia.org/wiki/Bruce_Lee)) has made at least one edit every day since September 6, 2011. That's 11 years, 4 months, 14 days and counting.
Appropriately featured on their user page is a userbox that says: "This user doesn't sleep much".

It is mind blowing to me the level of consistency you need to edit Wikipedia every day, for this long. There are so many things that could happen to stop you from editing Wikipedia (internet goes out, you go on vacation, etc.) and they
manage to continue editing regardless.

I also ran a variation of the query that only considered edits to articles. The winner there is [AnomieBOT](https://en.wikipedia.org/wiki/User:AnomieBOT), a set of automated processes written and operated by [Anomie](https://en.wikipedia.org/wiki/User:Anomie).
AnomieBOT last took a break from articles on August 6, 2016, and hasn't missed a day since.

You can see the full list of results on-wiki as part of the database reports project: [Longest active user editing streaks](https://en.wikipedia.org/wiki/Wikipedia:Database_reports/Longest_active_user_editing_streaks)
and [Longest active user article editing streaks](https://en.wikipedia.org/wiki/Wikipedia:Database_reports/Longest_active_user_article_editing_streaks). These will update weekly.

Hopefully by now you're wondering what your longest streak is. To go along with this project, I've created a new tool: [Wiki streaks](https://streaks.toolforge.org/). Enter in a username and wiki and see all of your streaks
(minimum 5 days), including your longest and current ones. It pulls all of the days you've edited, live, and then segments them into streaks. The [source code](https://gitlab.wikimedia.org/toolforge-repos/streaks) (in Rust of course)
is on Wikimedia GitLab, contributions welcome, especially to improve the visualization HTML/CSS/etc.

I think there is a lot of interesting stats out there if we kept looking at streaks of Wikipedians. Maybe Wikipedians who've made an edit every week? Every month? It certainly seems reasonable that there are people out there who've
made an edit at least once a month since Wikipedia started.

Of course, edits are just one way to measure contribution to Wikipedia. Logged actions (patrolling, deleting, blocking, etc.) are another, or going through specific processes, like getting articles promoted to "Good article" and
"Featured article" status. For projects like Commons, we coud look at file uploads instead of edits. And then what about historical streaks? I hope this inspires others to think of and look up other types of wiki streaks :-)
