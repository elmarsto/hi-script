

#Basic syntax 

##Comments

`-- this is a comment`

##Lexing (tokenization)


Whitespace separates lexical tokens. 

Whitespace (including newlines and carriage returns) is otherwise ignored. 

All non-whitespace unicode characters are valid in a token. 

Characters which are in the set of operator symbols (TODO define) are treated specially in two respects. A word literal may be composed entirely of non-operator characters or entirely of operator characters, but not both. 

If there is an operator adjacent to a non-operator, whitespace between the two is implied, and may be omitted. 

e.g. 

'foo=' lexes as 'foo ='; 'foo==' lexes as 'foo ==' ...


#Literals

##Atomic literals


 - `"String!"`
 - `5`

##Composite literals 


 - `[ "array", 1, 2, 3 ]`
 - `{ map: "of stuff, aka an object" }`

##Rules governing literals

 - Stating a literal puts it on the stack.


#Fundamental concepts

##Stack


CHANGED; TODO think about it
The latest value is at index `1``.
The earliest value is at index `-1`. The second earliest at -2...
`\_` pops the value at index 1.
Stating a literal puts it on the stack. 

##Labels

Named variables aren't present. However, functionality similar to named variables is provided by _Reactive Stack Indices_. 

An RSI is an index to a particular stack depth that is automatically updated when intervening elements are added and removed. 

For short, RSIs are often called 'labels'. 

A label is declared at the current stack depth by using the = primitive. 

"blah blah"
foo= 1   -- label foo now points to the value at stack index 0, which is 1

"more blah blah" 
      
         -- foo now points to stack index 1, which still contains the value 1

Redeclaring a label changes its value.

There is no way of undeclaring a label. 

More locally-scoped labels occlude more globally-scoped labels.

A label may not contain operator characters or whitespace.
If a word literal is recognized as a label, it is expanded to the value pointed to by that label. 

e.g. 

foo= "hello!"
print foo  -- user sees "hello!"

If a word literal that is recognized as a label is preceeded by a #, it expands to a numeric literal indicating the current stack depth picked out by the label. 

e.g. 

foo= "hello!"
print #foo  -- user sees '0'

If a numeric literal n is preceeded by a $, it expands to an anonymous label picking out stack depth n. 

"foo!"
print $1  -- user sees '"foo!"'

If a word literal w is followed by a :=, which in turn is followed by a numeric literal n , then a new label w pointing to stack depth n is created.

e.g.

bar= "foo!"
-- ...
baz:= #bar

print bar -- "foo!"
print baz -- "foo!"


If a word literal that is recognized as a label is preceeded by a %, it expands to a string literal containing the label name.

e.g.

foo= "hello!"
print %foo  -- user sees 'foo'

The @ operator, when followed by a numeric literal, expands to the value at that stack index. 

e.g. 

"foo!"
print @1  -- user sees "foo!"


Note the difference between @ and $. While similar, $ creates a new anonymous label. Thus #$1 always returns 1, whereas #@1 causes a runtime exception unless @1 happens to be a map or array. (# returns the length of the array in this context.) 


#Subroutines

A subroutine is defined with do/end.

foo= do 
      -- some stuff
     end

A subroutine always pops  _ as its only argument, and returns the value \_.

Every subroutine executes in a private stack. This stack is populated with its
sole argument. When it returns a copy of whatever was in the subroutine's _ is
pushed onto the returned-to stack. 

JSON objects (maps) are useful for both arguments and return values.

Subroutines are invoked with 'now'

e.g. 

foo= do 
      -- some stuff
     end
     now _ 






#Hoisting, unhoisting, dehoisting

A JSON object or array may be _hoisted_. This causes all further execution (until the next `unhoist`) to occur relative to a stack representation of that object. 

e.g. 

foo= [ 'this', 'is', 'an', 'example' ]
bar= { andThis : "is another" }

hoist foo

print _  -- user sees 'this'
print bar -- ERROR

baz= ['still','yet','another']
hoist baz
print _  -- user sees 'still'

dehoist  -- equivalent to 'unhoist baz unhoist foo'
hoist bar 

print andThis -- user sees "is another"

unhoist

From the above example, 'unhoist' is self-explanatory. dehoist is equivalent to calling 'unhoist' repeatedly, until all hoistings have been undone. 


#Closures

Closures are implemented by passing subroutines a JSON object containing a copy of the entire context. 

TODO figure out syntax.


