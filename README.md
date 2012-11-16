hi-script
=========

Hi-script (= 'HTTP Internet Script').  Suave but small, this understated little lady reuses URI conventions as calling parameters and transpiles to Javascript (ECMAScript). Major influences include Coffeescript, Forth, and Haskell. Currently a Node.js project, but plans for browser support.  WARNING: Pre-alpha until Jan 1 2013. 



##What hi-script brings

 - Familiar calling conventions
 - Seamless routing (throw out your routing tables and your .htaccess hacks...)
 - Friendly semantics powered by high-grade theory, like concurrency, Call-By-Push-Value, dependency injection, lazy evaluation and promises, monads and iterators, pipes and coroutines, REST and async IO. Hi makes these forbidding techniques fun and familiar. 
 - Terse! Oh my y.
 - Compiles down to pure Javascript (ECMAScript) 

##Details!

Every named function of hi-script is named not with a string of characters, but with an XPath expression and (optionally) a set of parameter filters. Functions are called via mentioning a matching path. Polymorphism happens via filtering and testing of parameters.

`<pre>when put@localhost/foo/bar/* ? foo=(string) & bar=(number:lt?10) do 
 --function body...
end

when put@localhost/foo/bar/* 
 --catch-all
end</pre>`
_N.B. a comment is introduced by a double dash (--)_

Calling is similar. Arguments are optionally passed after the ?:


`get@somewhere.org/some/thing ? foo=bar & baz`

##I want more! 

It's not quite ready yet. Want to help out? 

A first cut of the grammar in EBNF is available in the doc/ folder. Please
ignore the notes under 'historical', they are merely sketches of ideas, most of
which have been thrown out. Until I finish writing the language reference,
that's all I've got for you. 

##Please??!

Well.... okay :)

Here are a couple of teasers:

 - Operations are Forth-like; that is, they produce and consume values on a stack, and are specified in Reverse Polish Notation (RPN). This is a scary way of saying that you have to put the operator last. For example: '5 6 3 minus! plus!' is the proper way to say 5+(6-3). If this is annoying, don't fret: the language is extensible, and is certainly capable of understanding things like '5+(6-3)' if you show it how. 
 - The only control primitive is the pattern-matcher, 'when'. But the syntax is extensible enough that you are most certainly happy to add familiar synonyms. :)
 - Everything is either a deferred computation ('thunk'), a monad, or an atom literal (string or number or boolean). The monad, however, is just a JSON object, and so things like arrays and hash tables can be produced by suitably filtering the monad. I will explain more later.
 - Evented async dispatch will make it easy to call outside libraries and apps with the same ease as you'd call a function. Essentially, they're thing: aside from serving content over HTTP, the only special thing the dispatch daemon does is short the calls between hi functions, so that they don't have to loop back through the network stack. This is for efficiency. Semantically and syntactically, there is no difference between calling a function, loading a library, or handing off to a local or remote binary. 
 - Conceptually, a Hi app consists of a series of (very) small virtual machines consisting of a stack and a symbol table. Coding hi (no pun intended) is the act of crafting the relationships between these machines; passing around iterators; naming (routing) functions; etc. The stack comprises the function's body, and the symbol table provides support for closures (anonymous functions.)
 - Objects are not idiomatic in Hi. But anything you could do with an object, you could do with a monad, and a lot more besides.
 - Hi is not a 'pure' language, despite its penchant for monads. But mutation can only take place on the stack, and stacks aren't shared. This makes it easier to write performantly concurrent software (sorry Ruby), but still easy to write boring software.(Unlike Haskell, poor dear.) 
 - Hi blends the best aspects of low level programming and very high level programming. You get your simple, predictable primitives, but all the mathy power you need to finally shut up your annoying colleague who won't shut up about having gone to MIT. 
 - Monads in Hi are just little tiny Turing machines, set up so you can pipe the output of one into another. It's like networking a bunch of calculators together. Ironically, this turns out to be a much more efficient and expressive way of developing than what you're probably used to. And while it might not sound like it,
 - Hi is fun. Really, really fun. Enjoy coding again. 







