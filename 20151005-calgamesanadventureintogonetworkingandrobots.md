Title: CalGames 2015: An adventure into go, networking, and robots
Date: 2015-10-05 05:46
Category: Tech
Tags: golang, robots, calgames, stickers

This past weekend I volunteered at the 2015 CalGames tournament, which played the 2015 *FIRST* Robotics Competition game, Recycle Rush. This year CalGames had a few new things going on, and one of them was using a new field management system (FMS), called [Cheesy Arena](https://github.com/Team254/cheesy-arena). Cheesy Arena was written by Team 254 for their own offseason event and is branded as a "field management system that just works".

It's also written in go. I didn't know go. I still don't know go that well. Myself and [Lee](https://github.com/m3rcuriel) were in charge of making two major modifications to the system:

* Use the 2015 round robin elimination system instead of the traditional bracket
* Create an audience display to display the eliminations rankings

In retrospect, we should have lobbied during the rule change process to use the bracket system since the code was already written for that. Neither of us were involved in the conversation that early on, so we never had that opportunity though. And while it would have definitely made my life easier, I'm very fortunate it didn't happen because I got the opportunity to play with and learn some go.

So, the actual changes. Integrating into Cheesy Arena was actually pretty simple, the function to generate the next rounds in the bracket was called after every match was saved, so we replaced that function with our own that generated the schedule. To figure out what matches needed to be generated, we counted how many elimination matches were already scheduled, and how many had been played. If 0 had been scheduled, we generated the quarterfinals schedule. If only 8 had been scheduled and played, we sorted all the alliances by their cumulative score over the two matches, and advanced the top four. Our code was designed to be as uninvasive as possible, so we had to reverse engineer what alliances teams were on, since the mapping was only stored in the other direction (what teams are on each alliance). We also did not implement any of the tie breaking rules, and didn't really know what would happen if we encountered a tie. Lee and I quickly wrote some code to handle that while at the event Friday afternoon, but we never tested or deployed it. Luckily we never needed it :-).

With the backend of match schedule generation taken care of, we still needed a frontend to display the rankings. The audience displays were implemented with an HTML template, CSS, JavaScript animations and transitions, and websockets to communicate with the backend. Since my JavaScript is much stronger than go, I decided to have the backend export a list of all the teams, their scores, and how many matches they had played over websockets and do the sorting and table generation in JavaScript. I mostly grabbed code from the scoring display, and fiddled with the CSS so it looked like how I wanted it to, and was rather pleased with the result ([screenshot](//legoktm.com/images/cheesy-arena-rankings.png)). This was finished at about 11pm Thursday evening.

During setup of the event Friday morning, I got to learn about how the networking was configured. Cheesy Arena was running on a small Ubuntu Trusty machine, and was connected to a switch that all the driver stations were plugged into. There was another switch that provided internet access for pushing data to [The Blue Alliance](https://thebluealliance.com). All the laptops used for match controlling and scoring were connected to Cheesy Arena over ethernet cables, it was only accessible over WiFi for the FTA tablets that showed which robots had connected to the FMS. All of the critical networking equipment and Cheesy Arena server were on a dedicated UPS in case someone unplugged the field (it has happened in the past), while matches were running.

And...the event was mostly uneventful! All of the issues with robots not connecting properly were some kind of issue with the robot or an improperly configured driver station. Mostly it was people FORGETTING TO TURN ON THEIR ROBOTS. Really, how hard is it??

When it came time for eliminations, the backend code worked flawlessly, and scheduled all the matches properly. We did run into a really silly bug wih the rankings display bug though. When writing it, I was under the assumption that we would be using reasonably recent versions of Chromium, so I used the newly introduced [<code>String.prototype.startsWith</code>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/startsWith) function, because it made the code easier to read since it is the same as Python. Unfortunately the program that was managing the overlays and video stream was using an embedded Chromium 37, which didn't contain this function, so it would throw JavaScript errors. Quickly switching to <code>String.prototype.indexOf</code>. Once that was fixed, everything worked perfectly.

In the end, we only had one field fault in the very last finals match :(, which was due to an overload on the network, resulting in a "christmas tree" effect with robots flickering from green to red and back as they kept losing connections.

Overall, I had a lot of fun learning go. My experience with it was that it was very very hard to write crashy code in go. Whether it was trivial typos or glaring type errors, <code>go build</code> would refuse to complete if I had an issue in my code. I was only able to get go to crash once in all of my development, and that was due to a database level error that I suppressed. I'm not a huge fan of the go error handling model, but it very heavily enforces the "explicit is better than implicit" philosophy I love from Python.

I used "we" a lot above, none of this would have been possible without help from Alex M., Clayton, Mr. Mitchell, Lee, Novia, wctaiwan, Yulli, and all the other volunteers. I hope to be back next year!

Also, new laptop sticker ^.^

* [Modified version of Cheesy Arena that we ran](https://github.com/legoktm/cheesy-arena/tree/2015-elim)
* [Untested tiebreaking code](https://github.com/legoktm/cheesy-arena/tree/wip/tiebreakers)
* [Extremely silly upstream pull request I made](https://github.com/Team254/cheesy-arena/pull/13)

