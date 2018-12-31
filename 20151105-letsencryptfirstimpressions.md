Title: Lets Encrypt first impressions
Date: 2015-11-05 07:14
Category: Tech
Tags: letsencrypt

Today I spent two hours setting up an SSL certificate with Lets Encrypt for the [wikiconferenceusa.org](https://wikiconferenceusa.org) website.

It. Was. Easy. It was relatively straightforward, and I felt comfortable with all the steps I went through.

First, I cloned the git repository, and ran the `letsencrypt-auto` script, which installed the necessary dependencies and started setting up our account and fetching the SSL certificates. At this point it complained that we had a service running on port 80 (varnish) and that we had to stop it temporarily for the process to continue. That wasn't really ideal as it would have caused downtime. After asking in `#letsencrypt` on freenode, I was pointed to the `--webroot-path` option, which worked, and required no downtime!

At that point, the certificates were saved in `/etc/letsencrypt/` and ready for usage. Since we already had a different certificate for [wikimediadc.org](https://wikimediadc.org), we had to set up [SNI](https://en.wikipedia.org/wiki/Server_Name_Indication), which also was pretty straightforward. Except I made a typo and spent 30-45 minutes randomly debugging until I noticed it, and then everything worked!

In conclusion, it was really easy. I've signed up legoktm.com for their beta, hopefully it is approved soon, so you'll be able to read this over HTTPS :-)
