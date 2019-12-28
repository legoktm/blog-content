Title: Inside Scoop - Week 1: Welcome Back
Date: 2019-08-25 21:05:18
Category: Press
Tags: journalism, spartandaily, insidescoop

_Inside Scoop is a weekly column about the operation of the Spartan Daily, San Jose State's student newspaper._

It's been a minute, but school started on Wednesday, and we had to put out another issue ([10MB PDF](https://scholarworks.sjsu.edu/cgi/viewcontent.cgi?article=1044&context=spartan_daily_2019)). It turned out pretty nicely I think. We started working on it a few weeks beforehand, assigning stories, and then beginning to meet up and layout the pages starting a week beforehand (at least for the people who were already in town).

It was a true collaborative effort, with basically everyone on the editorial board contributing to the paper in one way or another, something I was really proud of. All the stories were written by editors, which was nice from the editing point of view (since they were well written to begin with), but it caused a few problems from the layout/production side, since the editors also had to focus on editing their own stories rather than just focusing on the pages.

For the first issue, we tried to make a "Welcome Guide" of sorts, partially to attract new students as readers. I don't think it really worked for the latter part, but we have a lot of work to do in that area. We're working on moving newsstands around to be in more convenient locations for readers to pick up, as well as looking into doing some focus testing to see what students are looking for.

The other main issue we've been dealing with is the rollout of our new website on <https://sjsunews.com/>. The architecture is bizzare to say the least - it's an AngularJS frontend calling out to a Drupal backend, where we enter content. I'm not really sure why that architecture was picked versus just creating a Drupal skin, but I also entered the process pretty late. I usually don't disclose to people my software background, to avoid all of the "oh can you help with this computer issue" type questions or get the responsibility of the website thrust upon me, but in this case I wish I had earlier. ¯\\_(ツ)_/¯

There are a decent amount of features missing but those are being worked on, I hope. Functionally, it's a pretty big regression from our other outdated website, but the design is nice when everything is finally rolled out.

As a sidenote, I also figured out why the old website was so slow to post articles - it used to take 10-15 minutes to show up. The old website was effectively a static site generator, and one of the sidebar items was "Recent articles". So whenever a new article is published, it would have to update every single generated page...which was over 30,000 of them. Yeah, not surprised that it took 10 minutes to publish a story.

All of the editors this semester are going to be writing a column or blog or some regular feature thing. So this is going to be mine - an inside look at the production of the Spartan Daily.
