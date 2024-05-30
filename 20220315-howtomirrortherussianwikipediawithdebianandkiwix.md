Title: How to mirror the Russian Wikipedia with Debian and Kiwix
Date: 2022-03-15 01:02:35
Category: MediaWiki
Tags: kiwix, debian, russia, offline, mirror, wikipedia

It has been reported that the Russian government has threatened to block access to Wikipedia for documenting narratives that do not agree with the official position of the Russian government.

One of the anti-censorship strategies I've been working on is [Kiwix](https://www.kiwix.org/), an offline Wikipedia reader (and plenty of other content too). Kiwix is free and open source software developed by a great community
of people that I really enjoy working with.

With threats of censorship, traffic to Kiwix has increased fifty-fold, with users from Russia accounting for 40% of new downloads!

You can download copies of every language of Wikipedia for offline reading and distribution, as well as hosting your own read-only mirror, which I'm going to explain today.

Disclaimer: depending on where you live it may be illegal or get you in trouble with the authorities to rehost Wikipedia content, please
be aware of your digital and physical safety before proceeding.

With that out of the way, let's get started. You'll need a Debian (or Ubuntu) server with at least 30GB of free disk space. You'll also
want to have a webserver like Apache or nginx installed (I'll share the Apache config here).

First, we need to download the latest copy of the Russian Wikipedia.

```bash
$ wget 'https://download.kiwix.org/zim/wikipedia/wikipedia_ru_all_maxi_2022-03.zim'
```

If the download is interrupted or fails, you can use `wget -c $url` to resume it.

Next let's install `kiwix-serve` and try it out. If you're using Ubuntu, I strongly recommend [enabling our Kiwix PPA](https://launchpad.net/~kiwixteam/+archive/ubuntu/release) first.

```bash
$ sudo apt update
$ sudo apt install kiwix-tools
$ kiwix-serve -p 3004 wikipedia_ru_all_maxi_2022-03.zim
```

At this point you should be able to visit `http://yourserver.com:3004/` and see the Russian Wikipedia. Awesome! You can use any available port, I just picked 3004.

Now let's use systemd to daemonize it so it runs in the background. Create `/etc/systemd/system/kiwix-ru-wp.service` with the following:

```ini
[Unit]
Description=Kiwix Russian Wikipedia

[Service]
Type=simple
User=www-data
ExecStart=/usr/bin/kiwix-serve -p 3004 /path/to/wikipedia_ru_all_maxi_2022-03.zim
Restart=always

[Install]
WantedBy=multi-user.target
```

Now let's start it and enable it at boot:

```bash
$ sudo systemctl start kiwix-ru-wp
$ sudo systemctl enable kiwix-ru-wp
```

Since we want to expose this on the public internet, we should put it behind a more established webserver and configure HTTPS.

Here's the Apache httpd configuration I used:

```apache
<VirtualHost *:80>
        ServerName ru-wp.yourserver.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Proxy *>
                Require all granted
        </Proxy>

        ProxyPass / http://127.0.0.1:3004/
        ProxyPassReverse / http://127.0.0.1:3004/
</VirtualHost>
```

Put that in `/etc/apache2/sites-available/kiwix-ru-wp.conf` and run:

```bash
$ sudo a2ensite kiwix-ru-wp
$ sudo systemctl reload apache2
```

Finally, I used [certbot](https://certbot.eff.org/) to enable HTTPS on that subdomain and redirect all HTTP traffic over to HTTPS. This is an interactive process that is well documented so I'm not going to go into it in detail.

You can see my mirror of the Russian Wikipedia, following these instructions, at [https://ru-wp.legoktm.com/](https://ru-wp.legoktm.com/). Anyone is welcome to use it or distribute the link, though I am not committing to running it long-term.

This is certainly not a perfect anti-censorship solution, the copy of Wikipedia that Kiwix provides became out of date the moment it was created, and the setup described here will require you to manually update the service
when the new copy is available next month.

Finally, if you have some extra bandwith, you can also help seed this as a [torrent](https://download.kiwix.org/zim/wikipedia/wikipedia_ru_all_maxi_2022-03.zim.torrent).
