Title: Introducing mwseaql, a crate for MediaWiki SQL query building
Date: 2022-10-09 03:45:00
Category: MediaWiki
Tags: mediawiki, mwbot, rust, mysql

I've published a new crate, [`mwseaql`](https://docs.rs/mwseaql/), which provides typed definitions of MediaWiki's SQL tables for use with the [`sea_query`](https://docs.rs/sea-query/) query builder.

It's a pretty simple implementation, there's a small Python script that parses MediaWiki's [JSON schema file](https://gerrit.wikimedia.org/g/mediawiki/core/%2B/HEAD/maintenance/tables.json) and outputs Rust structs.

Here's an example of it in use from my new [rfa-voting-history tool](https://gitlab.wikimedia.org/toolforge-repos/rfa-voting-history/-/blob/d7affdf36f256a766b84e02dacbe312d9fafd233/src/query.rs):

	:::rust
	use mwseaql::{Actor, Page, Revision};
	use sea_query::{Expr, MysqlQueryBuilder, Order, Query};

	let query = Query::select()
	    .distinct()
	    .column(Page::Title)
	    .from(Revision::Table)
	    .inner_join(
	        Page::Table,
	        Expr::tbl(Revision::Table, Revision::Page)
	            .equals(Page::Table, Page::Id),
	    )
	    .inner_join(
	        Actor::Table,
	        Expr::tbl(Revision::Table, Revision::Actor)
	            .equals(Actor::Table, Actor::Id),
	    )
	    .and_where(Expr::col(Page::Namespace).eq(4))
	    .and_where(Expr::col(Page::Title).like("Requests_for_adminship/%"))
	    .and_where(Expr::col(Actor::Name).eq(name))
	    .order_by(Revision::Timestamp, Order::Desc)
	    .to_string(MysqlQueryBuilder);

In MySQL this translates to:

	:::mysql
	SELECT
	  DISTINCT `page_title`
	FROM
	  `revision`
	  INNER JOIN `page` ON `revision`.`rev_page` = `page`.`page_id`
	  INNER JOIN `actor` ON `revision`.`rev_actor` = `actor`.`actor_id`
	WHERE
	  `page_namespace` = 4
	  AND `page_title` LIKE 'Requests_for_adminship/%'
	  AND `actor_name` = 'Legoktm'
	ORDER BY
	  `rev_timestamp` DESC

It's really nice having type definitions for all the tables and columns. My initial impression was that the function calls were harder to read than plain SQL, but it's very quickly growing on me.

I'm also interested in what it means to have SQL queries in a more easily parsable format. Recently there was a schema change to the `templatelinks` table that basically required everyone (see [Magnus's toot](https://mastodon.technology/@magnusmanske/109069636136476536))
to adjust their queries ([example](https://github.com/mzmcbride/database-reports/commit/6615ac347f48974a725dbe5d6948b06668c4885a)). What if we could have a macro/function that wraps each query and applies these types
of migrations at compile/run time? Some `let query = fix_my_query(query)` type function that automatically adds the correct join and updates columns based on whatever schema changes were made in MediaWiki (as much as is
technically possible to automate).

Lots of possibilities to consider! And mwseaql is just one of the components that make up the bigger [mwbot-rs](https://www.mediawiki.org/wiki/Mwbot-rs) project.

If this works interests you, we're always looking for more contributors, please reach out, either on-wiki or in the `#wikimedia-rust:libera.chat` room (Matrix or IRC).
