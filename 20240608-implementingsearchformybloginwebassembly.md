Title: Implementing search for my blog in WebAssembly
Date: 2024-06-08 05:18:24
Category: Tech
Tags: b2, rust, wasm

If you visit my blog (most likely what you're reading now) and have JavaScript
enabled, you should see a magnifying glass in the top right, next to the feed
icon. Clicking it should open up a search box that lets you perform a very
rudimentary full-text search of all of my blog posts.

It's implemented fully client-side using Rust compiled to WebAssembly (WASM),
here's all the [code I added](https://git.legoktm.com/legoktm/b2/commit/00c3c19a14f8471493a04ceb3d750238ea27282c)
to implement it.

At a high level, it:

1. Splits all blog posts into individual words, counts them, and dumps it
   into a search index that is a JSON blob.
2. Installs a click handler (using JavaScript) that displays the search bar and
   lazy-loads the rest of the WASM code and search index.
3. Installs an input handler (using WASM) that takes the user's input, searches
   through the index, and returns up to 10 matching articles.

The search algorithm is pretty basic, it gives one point per word-occurence
in the blog post, and 5 points if the word is in the title or a tag. Then it
sorts by score, and if there's a tie, by most recently published.

There's no stemming or language processing, the only normalization that
happens is treating everything as lowercase.

I've played with WASM before but this is the first time I've actually
deployed something using it. As much as I enjoyed writing it in Rust,
the experience left something to be desired. I had to use a separate
tool (`wasm-bindgen`) and load a pre-built JavaScript file first that
then let me initialize the WASM code.

The payload is also ...heavy:

* `search.js`: 5.53kB (23.63kB before gzip)
* `search_bg.wasm`: 53.78kB (122.82kB before gzip)
* `search_index.json`: 323.13kB (322.76kB before gzip)

I'm not sure why the index compresses so poorly with Apache, locally it goes
down to 100kB. (I had briefly considered using a binary encoding like
[MessagePack](https://en.wikipedia.org/wiki/MessagePack) but thought it
wouldn't be more efficient than JSON after compression.) And of course,
the more I write, the bigger the index gets, so it'll need to be addressed
sooner rather than later. I think any pure-JavaScript code would be much
much smaller than the WASM bundle.

