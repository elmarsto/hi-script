


	
#Language description

Comments are Lisp style, e.g. they are lines starting with -- and ending with \n. 
The statement delimiter is \n, except inside a multiline JSON literal.
Whitespace is never semantic, and is ignored everywhere except inside strings. 
By convention, httpscript source files are typeset in a columnar format that (vaguely and accidentally) resembles assembly. 

The central concept is the stack. There can be stacks of stacks, but for now just think about the main stack, which is pre-loaded with the values of the parameters passed to the function (and nothing else). The earliest (bottommost) element is referred to by the special symbol ^ (nm. regexp '^') and the latest (uppermost) element is referred to as 0. (I.e., it's a 0-based array.)

Stack elements may also be named with labels, so that they may be referred to directly (i.e. without pushing and popping.)

These labels are reactive stack indices. A 'reactive stack index' is an index to a particular entry that is incremented when intervening elements are added to the stack, and decremented when they are removed. That way, it always points to the same entry. They may also be used to specify ranges (and eventually slices). They may also be used for arithmetic, so e.g. 'label_1 + 1' is the label for the element immediately prior to label_1 on the stack. Finally, the value at a particular label is accessed with a prefixed tilde, i.e. ~label_1. 

Labels are declared by suffixing the first word of a statement with the equal sign:

label1= get http://foo.com/document.json    -- results of this at index 'label1' 

Other data types are all from JSON, and their literals are JSON. Types are, of course, number, string, array, map. 

Stating a literal puts it on the stack. Thus the stack may (only) contain elements that are arrays, numbers, strings, and maps. 
Brackets and braces may be used to specify JSON literals, especially multiline literals; however, they may be omitted for literals that fit on a single line. Single or double quotes signify a string literal, and must always be present, except when used around a map key, in which case they can be omitted (ugly, but it's for JSON compatibility) 

e.g.

--numbers
1
2
3 		-- Stack now contains three elements: 1, 2, 3 

--strings
Hello World 	-- BAD
"Hello World" 	-- GOOD
"Hello 	
World!"			-- GOOD, but notice that there is now an \n in the string


--arrays
  'Hello', 'World'  -- GOOD
[ 'Hello',
  'World' ] 		-- GOOD  

--maps
  hello: 'World' 	-- GOOD
{ hello: 
   'World' }		-- GOOD
{ 'hello':'World' }	-- GOOD, despite superfluous quotes around "hello"


Finally, the value of the latest stack entry is available via the special label _, which inside a function body is interpreted to mean 'whatever is at index 0 on the stack'. This may also be written _0, although it is uncommon to see it written this way. _1 accesses the second most recent element, and so forth. TODO think about and clarify this

e.g. 
"Hello World!"     			-- put string on stack
post ./print_string.php ? _ -- HTTP POST it as the only parameter to the relative URL ./print_string.php



Any line with a ?, !, or < in the third position is executable, and the first word is a function name.  If absent, the line is interpreted as a literal. 

The most common of the three is '?', which may be used to call any function in a manner that forbids it from modifying the stack. Parameters passed to the function are peeked at (copied) and are not removed from the stack. 
Any result from the function is interpreted as a single element and placed on the stack. If there are no results, the empty object {} is placed on the stack.

If there are no parameters to pass to the function, the ? may be omitted. 

Similar to ? is !. ! is used to call any function in a manner which DOES permit it to modify the stack. Any values from the stack passed as parameters to the function are removed from the stack. (they are 'popped'). However, the return value of the function is still interpreted as a single stack element. 

! is actually shorthand for '?!' but this is almost never used in practice (one extra character to type.)


Finally, there is <. < is different from ? and ! in that it permits attachments to be passed to a function. For instance, let's say you have a blurb of text that you'd like to post as an attachment:

label1= "some string, blah blah blah"
post  https://someplace.org/add_new.pl < label1

It may be combined with !, to signal that the value being passed should be removed (popped) from the stack:
post  https://someplace.org/add_new.pl <! label1

It may also be combined with a freestanding '!' or '?', so that attachments and parameters may be passed simultaneously, in any order.

e.g.

124
"Sensitivity training manual, ..."
post https://yomamma.net/not_funny ? employee_id=_ < _ 

"Sensitivity training manual, ..."
124
post https://yomamma.net/not_funny < _ ? employee_id=_  

-- same thing as above, but delete both values from stack when sent 
post https://yomamma.net/not_funny <! _ ! employee_id=_  
-- only delete the document
post https://yomamma.net/not_funny <! _ ? employee_id=_  
-- only delete the parameter 
post https://yomamma.net/not_funny < _ ! employee_id=_  

The last thing to know about it is that it is only possible to use < when calling a method which as declared a  < section in its signature. 

get  //slashdot.org/once_was_nice < _  -- WRONG

The second word is the direct object (target) of the function. Informally, it's what the function is about. It is often a URL. 

e.g. 

get //funtimes.org/whatever.json   

Parameters occur after the ? or !:

get //funtimes.org/whatever.json ? count=10

Just as in HTTP, HTTPScript separates parameters from one another with an ampersand:

get //funtimes.org/whatever.json ? count=10 & format='json' 

The ampersand may be used to make multiline calls (as may <, <!, !, and ? in fact!) 

post //funtimes.org/whatever.json ? count = 10  -- spaces will be automatically removed, but they enhance legibility meanwhile   
								  & format='json'
								  &  			-- an extra ampersand will be ignored;
								  < some_label 


##Method declarations

Methods are declared with 'when'. They are, in effect, pattern declarations, and are called whenever an HTTP request matches. 

when get //some-directory/bar.json do 
	...
end

Just as in CSS, the most precise match is preferred when the match is overdetermined; and between two equally precise declarations, the most recent is preferred.

A method may pass control to the next best match via 'yield'. It regains control after yielding.  

The keyword 'whenever' is just like 'when', except that the function *always* executes whenever the pattern matches. However, if multiple matching whenever-declared methods are present, they all execute concurrently and in parallel and in an arbitrary order. A 'whenever' method always runs, no matter what, and this makes them good for things like opening and closing filehandles. 

However, there is the following guarantee. If there is at least one matching 'when' method _and_ one or more 'whenever' methods, the whenever-method is always executed first, and the when-method is only executed when all running whenever-methods have reached 'yield'. When there are no when-methods associated with a match, then 'yield' in the context of a whenever-method is a noop. 

By the foregoing claim, if at least one whenever-method fails to yield, then no when-methods will ever execute. This could cause dramatic, cascading failures, should a third-party package declaring whenever-methods be poorly written. Thus there is an implied 'yield' at the end of every whenever-method. However, the same is not true of when-methods. Thus a when-method is able to break the chain of execution by neglecting to yield. 

For the sake of readability and consistency, the canonical style for HTTPScript is to end all methods with 'yield', whether needed or not. 

If no parameters are given to yield, the parameters originally supplied to the method are passed instead. This is actually syntactic shorthand for 

yield ...

This in turn is shorthand for either

yield ? ... < ... 

or 

yield ? ... 


because the token '...' means, 'supply original arguments here'. (Note that, as usual, the  <  is only permitted in the context of methods called via HTTP post or HTTP put.)


TODO describe constraints (e.g. regexps, validation functions) and expectations 


## Anonymous functions

Anonymous functions (closures) are declared inside a method (and only inside a method) by labelling a do-block. 

funcname=  do
	-- do some stuff
	discard * --clear the stack (so we return a {})
end

They live on the stack as a JSON structure, and thus may be serialized and passed around between methods. But in other ways they are more limited: unlike methods, they may not declare parameters, types, signatures or expectations. Their context is a copy of the stack that was present at their declaration, complete with labels. Whatever is in the stack when the function terminates is collapsed into a JSON named array (map) of labels and values. If the returning stack is empty, the empty object {} is returned. Thus a function will always leave the stack one element deeper, and may not, e.g., smash the stack, or mutate values in the stack. 

An anonymous function at label foo may be called by putting vertical bars (|) on either side of the variable name:

|foo| -- run anonymous function at foo, and leave its result on the stack


##Regular Expressions

A regular expression literal follows the traditional 'leaning toothpick notation'. 

e.g. 

foo=/.*/

A regular expression is actually an anonymous function that curries the '//regexp' method, passing it the regexp literal stripped of its /toothpicks/ as a string. Thus:


foo=/[aA]/g
t= "Some string to be tested for the letter a"
when |foo| do 

end

### Signature

The _signature_ of a method is comprised of:

 - The HTTP methods to which it applies
 - The named parameters it declares (and default values, if any)
 - The constraints it declares on its parameters (a /regexp/, a|0:range|,  or a |function|)
 - The expectations it declares about its return values

e.g.
-- IDEA!! put, post etc are just labels for anonymous functions. TODO EXPLORE! 

when put|post ./foo/*/bah ? foo|number & bar|0:20 & baz|is-date   




##Demonstration of various features 
when get /foo/bar ? foo=_												-- we don't care what's in bar, but it must be present
    		      & bar=|somefunc|						
    		      & qux=|json|											-- validation function (json, json-string, json-array, json-map are built-in)
    		      & baz=/^[Aa]/											-- validation regexp   
do
		'Hello World!'													-- Stating a literal puts it on the stack, right after the parameters
		1													
	    {  foo: 'bar' }											    	
	    [ 'foo', 'bar' ]											    -- any JSON literal is permitted
 l1=	'I love you'													-- labelling an entry gives you a reactive index to that stack depth
		put				./some_file  			< _						-- write the latest stack entry to ./some_file ( '_' is sugar for the latest stack entry)
		put				./some_file  			? _ < _					-- write the second-latest stack entry to ./some_file using the latest stack entry as parameters 
 l2=	get				//some.com/foo/bar 		?
	 	put				../foo 					? _						-- post value at some_label. If it's an array or map, flatten it into parameter list
		post			../foo 					? p=l					-- post present stack depth of value at l (useful for debugging) 
		post			../foo 					<    ~l					-- post value at label l
		post			../foo 					<   l:0				-- ranges work too (from depth of label l to latest) 
		put				./foo 					! *						-- * is sugar for the range ^:0 (i.e., the entire stack)
	 	post			//foo.com/blarg 		? ... < ...				-- call post on ../foo with clear stack except for args we were originally passed (perfect forwarding) and same attachments
	 	post			./baz 					?						-- peek first value on stack, post to URL
	 	post			./baz 					!						--  pop first value on stack, post to URL
	 	redir       	../foo 					? ...					-- redirect with same arguments (and HTTP method) that we received 
		hoist 		 	l					    ? 						-- enter the context of the array or map at l (all subsequent stack and label operations happen in this context)
		unhoist									?						-- reverse most recent hoisting
		dehoist									?						-- unhoist repeatedly until we can't unhoist any more
		collapse		l 						!
		collapse		l 						?
		expand			l 						!
		expand			l 						?


-- get is assumed if HTTP method not stated
-- pattern literal for deep access to JSON: < { somespecifickey : [ |string|, _, * ] } > 
-- alternative syntax: XPath-like? TODO research XPath. 
{ |string| }
[ |foo| ] 


Basic underlying syntax idea: primitives are a series of concepts: 

When it follows the first word literal on a line, '=' establishes an RSI (LHS) to whatever the current stack address is. 
It is the main way new labels are created. 

Magic labels: _ and ^

_ is a magic label that always picks out the latest stack element.
^ is a magic label that always picks out the index of the earliest stack element. 

Thus, e.g.,  #_ is always 0. 

# followed by a word literal causes the current numeric value of that index to be pushed onto the stack as an atomic numerical JSON value. 

@ followed by a number literal causes the value at stack index <number> to be copied and pushed as a new element onto the stack
Thus, e.g., @0 is always _, and @^ is the value of the earliest stack element.


Ranges
------
When it is surrounded by number literals n and m, n : m expands to the literal [n, n+1, ..., m]

Booleans
------
literals: 'true' and 'false' 
negation operator '~'
negop works on a literal, a parenthetical expression, or (if neither of those is handy) the latest stack element, which is consumed. 

Speaking of which: '==', '<', and '>' are all primitives that work the way you'd expect. == can be used on any JSON type, but < and > can only be used on numbers, strings, and booleans.  TODO explain how they interact with literals, modelled on 4-banger math below

+, -, /, *, (, ) :

if surrounded by numeric literals, perform the operation
if numeric literal only on LHS, then the other is implicitly the current value of _
if numeric literal only on RHS, pop value of _ as LHS , then push result (so it's pointed to by _)
if no numeric literal on either side, then perform operation on 2 latest stack elements, pop them, and push result onto stack.

When | is followed by a word literal, or an expression that resolves to a word literal, that word literal is taken as the RSI of a function; execution passes to the function at that literal, a new stack namespace is hoisted, and the entire previous namespace is flattened into a JSON object and left as the first and only item on the new stack.

When | follows a word literal nearly the same thing applies.  When the function identified by the word literal terminates, its stack minus its earliest element is flattened into a JSON object and left on the stack. If | also began the word literal, then the latest element on the containing stack is dropped. If the returning stack is not empty, then it is flattened into a JSON array and is placed on the containing stack. In effect, every function call that ends with a | is also an implied 'pop', and if the later stack is non-empty, it is an implied 'push' of a JSON object containing that stack. 

Thus an expression like '|foo|' pops a value off the stack, runs it through foo, and puts the result of foo on the stack. Note, however, that this is not isomorphic with mutating the value on the top of the stack, because any RSI pointing to it will be cleared. 

If two expressions occur like |foo||bar|, the second middle bar may be omitted: |foo|bar|. This allows simple composition of functions.


If an expression other than a word literal appears on the right or left of an expression which is not just a word literal (IOW, a compound expression)

The keywords 'do' and 'end' respectively begin and end an anonymous function declaration. They leave a JSON structure describing the function on the stack.
