


when put  glob:/* ? foo=|string|  & bar=|integer|
	|<>| -- this iterator will print one line of the put document to stdout every time it is run
end

	
when put  glob:/* ? foo=|string|  & bar=|integer|
	
	<< |<>| -- buffer putted document on stack as an array element
	
	|_ @/fun/scrambler ? 'reverse'| -- top of stack is now an iterator 

end	
-- n.b. remember that literals are just thunks that reproduce themselves when thunked. e.g. '1' is a thunk that returns 1. 
-- this also means that e.g. 1 == |1| == ||1|| ....
-- TODO explore consequences


--OMG look what I'm doing with 'put' here. TODO think about it. 'put' is an iterator

when put@path:/qux ? foo=|string|  & bar=|integer|
	
	|<| put thunk on top of the stack that always returns the next line. 
	
 	-- |@reverse| -- map 'reverse' over the iterator on the stack
end

--in addition, 'when' and 'end' are just synonyms for '|'
--for convenience, instead of the above (omitting arguments for clarity):
--match literals, such as path:/qux/, are compiled to thunks that iterate over successful matches.
--put, get, delete, and post are themselves iterators over the request object
--it seems crazy to apply an iterator to an iterator, but it makes perfect sense when you remember
--that an array is just an applied iterator. 


|put@filterfunc!;|<|@reverse||


-- I think the ! can be dropped from the spec; let the line delimiter or the alternative line delimiter (;) close the call and stand for 'force' 

-- consequences to think about: mentioning a function now calls it. 

|put@filterfunc!;|<|@reverse||


Change the | to () for readability? TODO?


(put@filterfunc; (< | @reverse))


(requests_to_reverse; (< | @reverse))

--further idea: let-declarations (for example, parameters specified with '?') are themselves implemented as thunks. e.g. within the declaration, a parameter named 'foo' is just a thunk that, when run, returns its value as a single result. 

--further idea: naming (eg with ?) just is JSON specification of key/value pairs. But let this apply at the global level too!

{ 

   foo: (put@filterfunc; (< | @reverse)), 
   ...

} 

--in other words, this language just became homoiconic. 



--further further idea: use '^' to signify 'drop' (nm. rewind stack upward once) and '$' to signify 'swap' (nm. dollar sign looks like s for swap)  This is nice because now you have <, >, ^, + and _ as your most common stack control primitives. This shit is getting tight.

e.g.

myfunc: ( put@path:/; < < $ ^ _ > )

This is getting confusing, retreating temporarily to old notation


when put@path:/

end
 


when put@path:/some/foo.action
   < < "foo" ^ _ ^ > > 
   ../some_other/action ? p=_ & 
end

--using current stack as stdin to a called function
when put@path:/some/foo.action
   << --put entire stdin on stack
   (range:^/$ @ some/other/action!)
end

when put@path:/some/other/action 
   <>
end

-- when called, the above returns an iterator that when called, takes a line and sends it to stdout

-- simplify it with anonymous functions


--IDEA use --- for multiline comments
--all comments are markdown-formatted.
---
foo
---

-- IDEA recognize <html>literals</html> as JSON-encoded DOM. (What's the standard for this? TODO research)


---
How do filters work?

Like this. Behold a simple filter for checking an array of boolean values for 'foo'
---

when ./filter-for-foo
   
   <
   when ( _  "foo" eq! ) ;  > 
   
end
   
---alternative syntax options. I think these are all strictly equivalent? 

   when ( eq? "foo" & < ) 
      -- ...
   end

   when <!@eq?"foo" 
      -- ...
   end


   when <@eq?"foo" 
      -- ...
   end
end
---

--simplify:


when ( < "foo" eq! ) ; > 



But a filter is just an iterator. 


so it should be possible to chain them with @



when <filter-out-anything-but-put>@<filter-out-any-other-paths>


end


-- swap every pair of lines
when put@path:/foo/bar
   (< < $ > >)
end

-- reverse order

when put@path:/foo/bar
   <<
   (>)
end
  

-- internal structure for matchers something like:

{
   type: 'parser', 
   name: 'regexp',
   guard: '/',
   multiline: true,
   escape: '\',
   parse: { how: 'so'
            what: [ 'libregexp.so', '__parse' ],
            args: { before: [ true, 3.14 ] } 
           } 

   ---TODO dependency injection? Possibly like the following

   parse: { how:   'di',
            where: 'local',
            provides: { service: 'regexp' } 
         } 
            
   ---       
}

{ 
   name: 'json-object',
   guard: ['{','}']
   multiline: true,
   escape: '\',
   parse: { how: 'primitive', 
            what: 'json', 
            args: { before: [ true, 3.14 ] } 
           } 
}


Registering a new service: 

{
   type: 'service',  
   provides: {
      regexp:  { how: 'so'
                 where: 'memory'  --advertise our efficiency
                 what: '' -- TODO
                 -- TODO...
               }

---
Let's say that where can take the values in order of preference

memory
file
net
wan

---

                 what:  ['libregexp.so','__parse'],
                 args:  {
                     after: "i"  -- case insensitivity
                 } 
                 
                 
      }
  


--- no priorty integer (I've decided) but later declarations in a particular 'where' override earlier

token: 
   literal: 
   foreign (UUID of plugin; else false)
   before: <pointer to token>
   after: <pointer to token>
   up: <pointer to line>


line:
   tokens: [ array of tokens ] 
   before
   after
   up   <pointer to file>


file: 
   before
   after
   origin '/* file://source.file, odbc://..., http://..., , with #hash fragment (e.g. #123 for representing line number*/'
   module  /* a path in hanoispace */
parse-tree-node: { 
   uuid:   
   module:     { path: '//localhost/some/path', uuid: } 
   file:   <pointer to file>
   tokens:  ...
   environment: { /* namespace at time of function declaration (for closures)*/  },
   parameters:     { /* parameters declared */ }, 
   validators: { /* paramname: validator-function */ } 
   matcher: /* matcher function (decides when this func executes) */ 
   stdin:      { /* iterator thunk */ } 
   stdout:     { /* iterator thunk */ }
   daughters:{ /* lower parse tree; empty until parsed */ }
   sisters: {  /* adjacent nodes */ } 
   sister-before
   sister-after
   mother:  { /* upper parse tree */ }
   lazy:   /* boolean; true for all parse nodes except data literals, and function name symbols called either with ?, !, or an implicit ! (i.e., newline \n) */ 
   action: 
}


--- pseudocode

lex() 
   foreach line in source
      check each line against language plugin table; bail if not found
         if found, use the language-specific tip and tail to make a big foreign token of everything until the language subsection closes, consuming the next line or two of the source as necessary for multiline arguments; mark resulting token as foreign, and mention UUID of the plugin to use
         else apply default lexer: ignore whitespace, separate plainwords from opwords, and treat '\n' as delimeter, and \ as excape char
      put resulting tokens in 'tokens'. want output like [ [ 'foo', 'bar', 'baz], [ 'qux', 'quux' ] ] , i.e. an array where each element is an array of tokens (that were on corresponding source line)
   end
   foreach token in tokens
      if the token is foreign, apply appropriate plugin 
      else apply hanoi parser.
      


hanoi parser(token)
   
   _, return a function that when called, pops the stack and returns the popped value. 
   ~, return a function that when called, peeks at the stack and returns the value. 
   a key in our environment object, return a function that when called returns the corresponding value from the environment object. 
   a number, return a function that when called, adds that atom to the stack.
   a word or opword, followed by a !, treat as forced function (see final clause, below)
   a foreign token (marked as such in lexing) look up and call foreign parser with supplied plugin UUID. 
   ^, return a function that pops a stack element and returns nothing
   @, return a function that treats the LHS (or the top stack member if no LHS) as stdinh TODO
   <, return a function that pops from stdin and pushes to stack
   >, return a function that pops from stack and pushes to stdout
   |<, return a function that repeatedly pops from stdin and pushes to stack until stdin depth is 0
   >|, return a function that repeatedly pops from stack and pushes to stdout until stack depth is 0
   (, a new thunk. call ourselves (recurse)
   ) or \n\n or EOF, end parsing of thunk, unwind
   if none of the above, and word or opword, run function matchers on literal. 
      if no matcher goes off, it's an unknown function, so bail. 
      else, return function that forces the named function



standard plugins
   plugin to parse json string literals ("" or '')
   plugin to parse json object literals ({})
   plugin to parse json array literals  ([])
   plugin to parse json array access (foo['bar'])
   plugin to parse json object access (foo.bar)
   plugin to parse regexen (regex://)
   plugin to parse xpaths  (xpath://)
   plugin to parse globs   (glob://)
   plugins for standard protocols  (file:, http:, https:, ftp:)
   plugin to parse slices , { : }, { : | } or * 
   plugin to parse xml  <foo> </foo>

