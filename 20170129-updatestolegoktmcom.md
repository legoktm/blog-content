Title: Updates to legoktm.com
Date: 2017-01-29 10:40
Category: Tech

Over the weekend I migrated legoktm.com and associated services over to a new server. It's powered by Debian Jessie instead of the slowly aging Ubuntu Trusty. Most services were migrated with no downtime by rsync'ing content over and the updating DNS. Only git.legoktm.com had some downtime due to needing to stop the service before copying over the database.

I did not migrate my IRC bouncer history or configuration, so I'm starting fresh. So if I'm no longer in a channel, feel free to PM me and I'll rejoin!

At the same time I moved the main <a href="https://legoktm.com/">https://legoktm.com/</a> homepage to MediaWiki. Hopefully that will encourage me to update the content on it more often.

Finally, the <a href="https://atlas.torproject.org/#details/7B190463E733CC292AA4010D194D1798CD8EB9A0">tor relay node</a> I'm running was moved to a separate server entirely. I plan on increasing the resources allocated to it.
