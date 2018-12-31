Title: Goodbye PHPStorm, hello Atom
Date: 2018-09-08 03:57:49
Category: MediaWiki
Tags: mediawiki, php, atom, freedom, phpcs

I've been using the JetBrains IDE PHPStorm ever since I really got started in MediaWiki development in 2013. Its symbol analysis and autocomplete is fantastic, and the built-in inspections generally caught most coding issues while you were still writing the code.

But, it's also non-free software, which has always made me feel uncomfortable using it. I used to hope that they would one day make a free/libre community version, like they did with their Python IDE, PyCharm. But after five years of waiting, I think it's time to give up on that hope.

So, about a year ago I started playing with replacements. I evaluated NetBeans, Eclipse, and [Atom](https://atom.io/). I quickly gave up on NetBeans and Eclipse because it took too long for me to figure out how to create a project to import my code into. Atom looked promising, but if I remember correctly, it didn't have the symbol analysis part working yet.

I gave Atom a try again two weeks ago, since it looked like the [PHP 7 language server](https://github.com/felixfbecker/php-language-server) was ready (spoiler: it isn't really). I like it. Here's my intial feelings:

* The quick search bar (ctrl+t) has to re-index every time I open up Atom, which means I can't use it right away. It only searches filenames, but that's not a huge issue since now most of MediaWiki class names match the filenames.
* Everything that is .gitignore'd is excluded from the editor. This is smart but also gets in the way, when I have all MediaWiki extensions cloned to extensions/, which is gitignored'd in core.
* Theme needs more contrast, I need to create my own or look through other community ones.
* Language server regularly takes up an entire CPU when I'm not even using the editor. I don't know what it's doing - definitely not providing good symbol analysis. It really can't do anything more advanced than things that are in the same file. I'm much less concerned about this since [phan](https://www.mediawiki.org/wiki/Continuous_integration/Phan) tends to catch most of these errors anyways.
* The [PHPCS linter plugin](https://github.com/AtomLinter/linter-phpcs) doesn't work. I need to spend some time understanding how it's supposed to work still, because I think I'm using it wrong.

Overall I'm pretty happy with Atom. I think there are still some glaring places where it falls short, but now I have the power to actually fix those things. I'd estimate that my productivity loss in the past two weeks has been 20%, but now it's probably closer to 10-15%. And as time goes on, I expect I'll start making productivity gains since I can customize my editor significantly more. Hooray for software freedom!
