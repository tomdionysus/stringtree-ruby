README

-Purpose-
StringTree is a (very) fast forward-only matching tokeniser, that is, it can:

(1) Load a dictionary of arbitarty size and record count - e.g. an actual dictionary, an english word list - where each record is associated with a key- e.g. a numeric identifier for the word.
(2) Parse an arbitary data string in a single pass, finding and storing instances of each item in the dictionary and storing their offsets and associated keys.

This has become my 'hello world' over the years with any new language. I use it to get to know a language, as implementing it correctly involves many of the usual concepts needed get started coding from the hip (syntax, grammar, classes, public/private instance vars, statics, pass-by value/pass-by-reference etc.) not to mention usual code support skills like how to set up unit tests for this language and environment, etc.

-Implementation-
Stringtree is based on multidimensional binary trees - Each node in the tree has its usual left/right references to its children, but also an optional 'down' reference, which would refer to the root of the binary tree representing the next character in the string from this point. This version also has an 'up' reference on the node which can be faster for iterating backward through a set of trees.

From a CS point of view, StringTree is a specific implementation of a nested n-dimensional trie.

-Performance-
StringTree on a my home dev machine (Quad Core2, Ubuntu), under ruby, can average approximately 75,000 matches per second using an english dictionary (optimized) and a copy of Hamlet or War and Peace.

-Limitations-
* StringTree is not intended for and should not be used as a key/value store. There are much faster algorithims for storing such data. 
* StringTree should not be used in place of regular expressions. StringTree is good when the total number and/or size of the tokens to be found is either unknown or dynamic.
* StringTree is essentially a byte tokeniser and is case-sensitive. It would be trivial to extend it to search in an case insensitive manner, however.

-Applications-
StringTree has the following applications:
* Spellchecking
* Virus scanning
* Partial string matching, e.g. autocomplete
* Tokenizing, e.g. Matching Bank Transaction data to Businesses from reference/particular/code fields, etc.

-Environment-
The demo is tested and runs under Ruby 1.9.3, and will probably work under earlier and later versions but this is not guaranteed. The unit tests require rspec also:
> rvm use 1.9.3
> bundle install

-Unit Tests-
> rspec specs/string_tree_spec.rb

-Demo-
> ruby demo.rb

This will generate two files:
* hamlet.tokens.txt
* warandpeace.tokens.txt

each of which contain a set of lines as such:

28: platform 41003 (8)

Where 28 is the offset where the token was found, 'platform' is the token itself, 41003 is the id of the token (in this case the line number of the dictionary file), and (8) is the length of the token.

The demo code then goes into a console, which will do partial searches within the dictionary. Type a partial word and press enter, and the demo will show all words in the dictionary that start with the partial entered.
Type 'exit' to finish the demo.

-References-
http://www.ruby-doc.org/
http://en.wikipedia.org/wiki/Trie

Tom Cully, Sep 2012