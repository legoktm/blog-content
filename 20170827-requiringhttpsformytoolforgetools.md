Title: Requiring HTTPS for my Toolforge tools
Date: 2017-08-27 00:00
Category: MediaWiki

My Toolforge (formerly "Tool Labs") tools will now start requiring HTTPS, and redirecting any HTTP traffic. It's a little bit of common code for each tool, so I put it in a [shared "toolforge" library](https://wikitech.wikimedia.org/wiki/User:Legoktm/toolforge_library).

<pre>
from flask import Flask
import toolforge

app = Flask(__name__)
app.before_request(toolforge.redirect_to_https)
</pre>

And that's it! Your tool will automatically be HTTPS-only now.

<pre>
$ curl -I "http://tools.wmflabs.org/mwpackages/"
HTTP/1.1 302 FOUND
Server: nginx/1.11.13
Date: Sat, 26 Aug 2017 07:58:39 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 281
Connection: keep-alive
Location: https://tools.wmflabs.org/mwpackages/
X-Clacks-Overhead: GNU Terry Pratchett
</pre>

