Title: Wikimedia Hackathon at home project
Date: 2017-06-25 02:38
Category: MediaWiki

This is the second year I haven't been able to attend the Wikimedia Hackathon due to conflicts with my school schedule (I finish at the end of June). So instead I decided I would try and accomplish a large-ish project that same weekend, but at home. I'm probably more likely to get stuff done while at home because I'm not chatting up everyone in person!

Last year I [converted OOjs-UI](https://gerrit.wikimedia.org/r/#/c/280595/) to use PHP 5.5's traits instead of a custom mixin system. That was a fun project for me since I got to learn about traits and do some non-MediaWiki coding, while still reducing our technical debt.

This year we had some momentum on MediaWiki-Codesniffer changes, so I picked up one of our largest tasks which had been waiting - to upgrade to the 3.0 upstream PHP_CodeSniffer release. Being a new major release there were breaking changes, including a huge change to the naming and namespacing of classes. My current diffstat on the [open patch](https://gerrit.wikimedia.org/r/#/c/355067/) is +301, -229, so it is roughly the same size as last year. The conversion of our custom sniffs wasn't too hard, the biggest issue was actually updating our test suite.

We run PHPCS against test PHP files and verify the output matches the sniffs that we expect. Then we run PHPCBF, the auto-fixer, and check that the resulting "fixed" file is what we expect. The first wasn't too bad, it just calls the relevant internal functions to run PHPCS, but the latter would have PHPBCF output in a virtual filesystem, shells out to create a diff, and then tries to put it back together. Now, we just get the output from the relevant PHPCS class, and compare it to the expected test output.

This change was included in the 0.9.0 release of MediaWiki-Codesniffer and is in use by many MediaWiki extensions.
