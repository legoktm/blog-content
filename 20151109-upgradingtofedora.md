Title: Upgrading to Fedora 23
Date: 2015-11-09 01:08
Category: Tech
Tags: fedora, vagrant, virtualbox

I upgraded to Fedora 23 last night, and it went pretty smoothly.

I started with <code>sudo dnf system-upgrade download --releasever=23</code>, which started with a fun dowload of 2.5G of package upgrades (still better than Xcode!). I ran into the [documented](https://fedoraproject.org/wiki/Common_F23_bugs#Upgrade_path_for_Vagrant_broken_.28rubygem-celluloid_retired.29) upgrade issue with the <code>vagrant</code> package, but the workaround of <code>--allowerasing</code> fixed it.

All the copr and rpmfusion packages I was using were all set for Fedora 23, and nearly all worked right away (more on that in a bit).

Then came the scary <code>sudo dnf system-upgrade reboot</code>. I entered in my encryption password, and it started spewing out the list of packages it was going to upgrade. Aaand then about a thousand packages in, it [went screwy](/images/20151108-twitter-663248891534381057-1.jpg). After freaking out for a few seconds and tweeting about it (priorities!), I hit esc to go into the GUI mode, and esc again for text mode, and everything was fine. Yay!

Everything else went fine, and it booted up into Fedora 23 properly. The first thing that went wrong was that it did not automatically connect to my wifi network, and it couldn't see any of them. Turning the wifi off and on fixed it. I had seen thiis issue once on Fedora 22, so I don't think this is a new regression. Since VirtualBox broke last time, I tested it next...and it was broken. The kernel module wasn't built. I noticed that the <code>kernel-debug</code> and <code>kernel-debug-devel</code> had not been upgraded, so I ran <code>sudo dnf update --best --allowerasing</code> to force their upgrade. After a reboot and <code>sudo akmods</code>, VirtualBox started up! (Related, there's been some progress on getting [MediaWiki-Vagrant to work with libvirt](https://phabricator.wikimedia.org/T71223) so I can drop VirtualBox.)

After that, I tested out Chromium and PyCharm since they are from a copr repository, and both worked fine. The only major thing left I haven't tested is the Google Hangouts plugin, but I try and avoid using it so that might take a while.

Overall, this upgrade went pretty nicely, and felt relatively non-disruptive. So far the most jarring difference is the new wallpaper. :-)
