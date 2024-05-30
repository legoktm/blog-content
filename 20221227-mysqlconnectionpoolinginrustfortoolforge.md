Title: MySQL connection pooling in Rust for Toolforge
Date: 2022-12-27 00:24:42
Category: MediaWiki
Tags: toolforge, rust, mysql, mwbot

[Toolforge](https://wikitech.wikimedia.org/wiki/Help:Toolforge) is a free cloud computing platform designed for and used by the Wikimedia movement to host various tools and bots. One of the coolest parts of using Toolforge
is that you get access to redacted copies of the MediaWiki MySQL database replicas, aka the [wiki replicas](https://wikitech.wikimedia.org/wiki/Wiki_Replicas).
(Note that whenever I say "MySQL" in this post I actually mean "MariaDB".)

In web applications, it's pretty common to use a [connection pool](https://en.wikipedia.org/wiki/Connection_pool), which keeps a set of open connections ready so there's less overhead when a new request comes in. But the wiki replicas
are a shared resource and more importantly the database servers don't have enough connection slots for every tool that uses them to maintain idle connections. To quote from the [Toolforge connection handling policy](https://wikitech.wikimedia.org/wiki/Help:Toolforge/Database#Connection_handling_policy):

<blockquote>
Usage of connection pools (maintaining open connections without them being in use), persistent connections, or any kind of connection pattern that maintains several connections open even if they are unused is <strong>not permitted</strong> on shared MySQL instances (Wiki Replicas and ToolsDB).
<br><br>
The memory and processing power available to the database servers is a finite resource. Each open connection to a database, even if inactive, consumes some of these resources. Given the number of potential users for the Wiki Replicas and ToolsDB, if even a relatively small percentage of users held open idle connections, the server would quickly run out of resources to allow new connections. Please close your connections as soon as you stop using them. Note that connecting interactively and being idle for a few minutes is not an issue—opening dozens of connections and maintaining them automatically open is.
</blockquote>

But use of a connection pool in code has other benefits from just having idle connections open and ready to go. A connection pool manages the max number of open connections, so we can wait for a connection slot to be available rather
than showing the user an error that the number of connections for our user has already been met. A pool also allows us to reuse open connections if we know something is waiting for them instead of closing them. (Both of those are
real issues [Enterprisey](https://en.wikipedia.org/wiki/User:Enterprisey) ran into with their new fast-ec tool: [T325501](https://phabricator.wikimedia.org/T325501), [T325511](https://phabricator.wikimedia.org/T325511); which caused
me to finally investigate this.)

With that in mind, let's set up a connection pool using the [`mysql_async`](https://docs.rs/mysql_async/) crate that doesn't keep any idle connections open. You can pass pool options programatically using a builder, or as part of the
URL connection string. I was already using the connection string method, so that's the direction I went in because it was trivial to tack more options on.

Here's the annotated Rust code I ended up with, from the [`toolforge` crate](https://lib.rs/crates/toolforge) ([source code](https://gitlab.wikimedia.org/repos/mwbot-rs/toolforge/-/blob/30c78c0108b0ec14585105be5f82429f8d274d18/src/db.rs#L51)):

```rust
impl fmt::Display for DBConnectionInfo {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        // pool_min=0 means the connection pool will hold 0 active connections at minimum
        // pool_max=? means the max number of connections the pool will hold (should be no more than
        //            the max_connections_limit for your user (default 10)
        // inactive_connection_ttl=0 means inactive connections will be dropped immediately
        // ttl_check_interval=30 means it will check for inactive connections every 30sec
        write!(
            f,
            "mysql://{}:{}@{}:3306/{}?pool_min=0&pool_max={}&inactive_connection_ttl=0&ttl_check_interval=30",
            self.user, self.password, self.host, self.database, self.pool_max
        )
    }
}
```

In the end, it was pretty simple to configure the pool to immediately close unused connections, while still getting us the other benefits! This was released as part of toolforge 5.3.0.

This is only half of the solution though, because this pool only works for connecting to a single database server. If your tool wants to support all the Wikimedia wikis, you're out of luck since the wikis are split across 8 different database servers ("slices").

Ideally our pool would automatically open
connections on the correct database server, reusing them when appropriate. For example, the "enwiki" (English Wikipedia) database is on "s1", while "[s2](https://noc.wikimedia.org/conf/highlight.php?file=dblists/s2.dblist)" has
"fiwki" (Finnish Wikipedia), "itwiki" (Italian Wikipedia), and a few more. There is a "meta_p" database that contains information about which wiki is on which server:

```
MariaDB [meta_p]> select dbname, url, slice from wiki where slice != "s3.labsdb" order by rand() limit 10;
+---------------+--------------------------------+-----------+
| dbname        | url                            | slice     |
+---------------+--------------------------------+-----------+
| mniwiktionary | https://mni.wiktionary.org     | s5.labsdb |
| labswiki      | https://wikitech.wikimedia.org | s6.labsdb |
| dewiki        | https://de.wikipedia.org       | s5.labsdb |
| igwiktionary  | https://ig.wiktionary.org      | s5.labsdb |
| viwiki        | https://vi.wikipedia.org       | s7.labsdb |
| cswiki        | https://cs.wikipedia.org       | s2.labsdb |
| enwiki        | https://en.wikipedia.org       | s1.labsdb |
| mniwiki       | https://mni.wikipedia.org      | s5.labsdb |
| wawikisource  | https://wa.wikisource.org      | s5.labsdb |
| fiwiki        | https://fi.wikipedia.org       | s2.labsdb |
+---------------+--------------------------------+-----------+
10 rows in set (0.006 sec)
```

(Most of the wikis are on s3, so I excluded it so we'd actually get some variety.)

Essentially we want 8 different connection pools, and then a way to route a connection request for a database to the server that contains the database. We can get the mapping of database to slice from the `meta_p.wiki` table.

This is what the new [`WikiPool`](https://gitlab.wikimedia.org/repos/mwbot-rs/toolforge/-/blob/30c78c0108b0ec14585105be5f82429f8d274d18/src/pool.rs) type aims to do (again, in the `toolforge` crate).
At construction, it loads the username/password from the
my.cnf file. Then when a new connection is requested, it lazily loads the mapping, and opens a connection to the corresponding server, switches to the desired database and returns the connection.

I've done some limited local testing of this, mostly using `ab` to fire off a bunch of concurrent requests and watching `SHOW PROCESSLIST` in another tab to observe all connections slots being used with no idle connections
staying open. But it's not at a state where I feel comfortable declaring the API stable, so it's currently behind an `unstable-pool` feature, with the understanding that breaking changes may be made in the future, without a
semver major bump. If you don't mind that, please try out toolforge 5.4.0 and provide feedback! [T325951](https://phabricator.wikimedia.org/T325951) tracks stabilizing this feature.

If this works interests you, the mwbot-rs project is always looking for more contributors, please reach out, either [on-wiki](https://www.mediawiki.org/wiki/Mwbot-rs) or in the `#wikimedia-rust:libera.chat` room (Matrix or IRC).
