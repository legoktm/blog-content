Title: Speeding up Toolforge tools with Redis
Date: 2020-07-17 11:22:04
Category: MediaWiki
Tags: toolforge, wikisource, checker, wwiki, python, rust

Over the past two weeks I significantly sped up two of my [Toolforge](https://toolforge.org) tools by using Redis, a key-value database. The two tools, [checker](https://checker.toolforge.org/) and [shorturls](https://shorturls.toolforge.org/) were slow for different reasons, but now respond instantaneously. Note that I didn't do any proper benchmarking, it's just noticably faster.

If you're not familiar with it already, Toolforge is a shared hosting platform for the Wikimedia community build entirely using free software. A key component is providing web hosting services so developers can build all sorts of tools to help Wikimedians with really whatever they want to do.

Toolforge provides a Redis server ([see the documentation](https://wikitech.wikimedia.org/wiki/Help:Toolforge/Redis_for_Toolforge)) for tools to use for key-value caching, [pub/sub](https://redis.io/topics/pubsub), etc. One important security note is that this is a shared service for all Toolforge users to use, so it's especially important to prefix your keys to avoid collisions. Depending on what exactly you're storing, you may want to use a cryptographically-random key prefix, see the [security documentation](https://wikitech.wikimedia.org/wiki/Help:Toolforge/Redis_for_Toolforge#Security) for more details.

Redis on Toolforge is really straightforward to take advantage of for caching, and that's what I want to highlight.

## checker

!["checker"]({static}/images/tool-checker.png)

[Visit the tool](https://checker.toolforge.org/) &mdash; [Source code](https://github.com/legoktm/checker)

checker is a tool that helps Wikisource contributors quickly see the [proofread status](https://en.wikisource.org/wiki/Help:Proofread) of pages. The tool was originally written as a Python CGI script and I've since lightly refactored it to use Flask and jinja2 templates.

On each page load, checker would make a database query to get the list of all available wikis, and then an additional query to get information about the selected wiki and an API query to get namespace information. This data is basically static, it would only change whenever a [new wiki is created](https://lists.wikimedia.org/pipermail/newprojects/), which is rare.

```irc
<+bd808> I think it would be a lot faster with a tiny bit of redis cache mixed in
```

I used the [Flask-Caching](https://pythonhosted.org/Flask-Caching/) library, which provides convenient decorators to cache the results of Python functions. Using that, adding caching was about [10 lines of code](https://github.com/legoktm/checker/commit/11c4cdd361c91a5ab7872297714a7f415fa71973).

To set up the library, you'll need to configure the Cache object to use tools-redis.

```python
from flask import Flask
from flask_caching import Cache
app = Flask(__name__)
cache = Cache(
    app,
    config={'CACHE_TYPE': 'redis',
            'CACHE_REDIS_HOST': 'tools-redis',
            'CACHE_KEY_PREFIX': 'tool-checker'}
)
```

And then use the <code>@cache.memoize()</code> function for whatever needs caching. I set an expiry of a week so that it would pick up any changes in a reasonable time for users.

## shorturls

!["shorturls"]({static}/images/tool-shorturls.png)

[Visit the tool](https://shorturls.toolforge.org/) &mdash; [Source code](https://gerrit.wikimedia.org/g/labs/tools/shorturls/)

shorturls is a tool that displays statistics and historical data for the [w.wiki URL shortener](https://w.wiki/). It's written in Rust primarily using the [rocket.rs](https://rocket.rs/) framework. It parses dumps, generates JSON data files with counts of the total number of shortened URLs overall and by domain.

On each page load, shorturls generates an SVG chart plotting the historical counts from each dump. To generate the chart, it would need to read every single data file, over 60 as of this week. On Toolforge, the filesystem is using [NFS](https://en.wikipedia.org/wiki/Network_File_System), which allows for files to be shared across all the Toolforge servers, but it's sloooow.

```irc
<+bd808> but this circles back to "the more you can avoid reading/writing to the NFS $HOME, the better your tool will run"
```

So to avoid reading 60+ files on each page view, I cached each data file in Redis. There's still one filesystem call to get the list of data files on disk, but so far that seems to be acceptable.

I used the [redis-rs](https://docs.rs/redis) crate combined with [rocket's connection pooling](https://docs.rs/rocket_contrib/0.4.5/rocket_contrib/databases/index.html). The change was about [40 lines of code](https://gerrit.wikimedia.org/r/c/labs/tools/shorturls/+/612703). It was a bit more invovled because redis-rs doesn't have any support for key prefixing nor automatic (de)serialization so I had to manually convert to/from JSON.

The data being cached is immutable, but I still set a 30 day expiry on it, just in case I change the format or cache key, I don't want the data to sit around forever in the Redis database.

## Conclusion

Caching mostly static data in Redis is a great way to make your Toolforge tools faster if you are reguarly making SQL queries, API requests or filesystem reads that don't change as often. If you need help or want tips on how to make other Toolforge tools faster, stop by the <code>#wikimedia-cloud</code> IRC channel or ask on the [Cloud mailing list](https://lists.wikimedia.org/mailman/listinfo/cloud). Thanks to [Bryan Davis (bd808)](https://wikitech.wikimedia.org/wiki/User:BryanDavis) for helping me out.
