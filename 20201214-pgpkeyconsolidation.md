Title: PGP key consolidation
Date: 2020-12-14 08:36:41
Category: MediaWiki
Tags: pgp, wikimedia, gpg

Note: A signed version of this announcement can be found at <https://legoktm.com/w/index.php?title=PGP/2020-12-14_key_consolidation>.

I am consolidating my PGP keys to simplify key management. Previously I had a separate key for my wikimedia.org email, I am revoking that key and have added that email as an identity to my main key.

I have revoked the key <code>6E33A1A67F4E2DF046736A0E766632234B56D2EC</code> (<code>legoktm at wikimedia dot org</code>). I have pushed the revocation to the SKS Keyservers and additionally published it at <https://legoktm.com/w/index.php?title=PGP/2020-12-14_revocation>.

My main key, <code>FA1E9F9A41E7F43502CA5D6352FC8E7BEDB7FCA2</code>, now has a <code>legoktm at wikimedia dot org</code> identity. An updated version can be fetched from keys.openpgp.org, the SKS Keyservers, or <https://legoktm.com/w/index.php?title=PGP>. It should also be included in the next Debian keyring update. I took this opportunity to extend the expiry for another two years to 2022-12-14.

