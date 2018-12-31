Title: Building the Lego Saturn V rocket 48 years after the moon landing
Date: 2017-07-20 21:14
Category: Life
Tags: lego, space, timelapse

<video controls>
 <source src="https://upload.wikimedia.org/wikipedia/commons/transcoded/8/81/Building_the_Lego_Saturn_V.webm/Building_the_Lego_Saturn_V.webm.360p.webm" type="video/webm">
 <source src="https://upload.wikimedia.org/wikipedia/commons/transcoded/8/81/Building_the_Lego_Saturn_V.webm/Building_the_Lego_Saturn_V.webm.360p.ogv" type="video/ogg">
</video>
<small>Full quality video available on <a href="https://commons.wikimedia.org/wiki/File:Building_the_Lego_Saturn_V.webm">Wikimedia Commons</a>.</small>

On this day 48 years ago, three astronauts landed on the moon after flying there in a Saturn V rocket.

Today I spent four hours building the Lego Saturn V rocket - the largest Lego model I've ever built. Throughout the process I was constantly impressed with the design of the rocket, and how it all came together. The attention paid to the little details is outstanding, and made it such a rewarding experience. If you can find a place that has them in stock, get one. It's entirely worth it.

The rocket is designed to be separated into the individual stages, and the lander actually fits inside the rocket. Vertically, it's 3ft, and comes with three stands so you can show it off horizontally.

As a side project, I also created a timelapse of the entire build, using some pretty cool tools. After searching online how to have my DSLR take photos on a set interval and being frustrated with all the examples that used a TI-84 calculator, I stumbled upon <a href="http://www.gphoto.org/">gphoto2</a>, which lets you control digital cameras. I ended up using a command as simple as <code>gphoto2 --capture-image-and-download -I 30</code> to have it take and save photos every 30 seconds. The only negative part is that it absolutely killed the camera's battery, and within an hour I needed to switch the battery.

To stitch the photos together (after renaming them a bit), ffmpeg came to the rescue: <code>ffmpeg -r 20 -i "%04d.jpg" -s hd1080 -vcodec libx264 time-lapse.mp4</code>. Pretty simple in the end!

