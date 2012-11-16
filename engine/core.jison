/*******************************************************
 *  Hanoi -- core language      			     			   * 
 *******************************************************/ 

%lex

DECA        [1-9]([0-9]*)
SYM         ([A-Za-z]([A-Za-z0-9]*)

%%
{DECA}      return 'UINT'
{SYM}       return 'SYMBOL'

\s+        /*skip whitespace*/
"--".*     /* ignore inline comment */

/* for declarations */
"when"      return 'WHEN'
"whenever"  return 'WHENEVER'
"between"   return 'BETWEEN'
"do"        return 'DO'
"="         return 'ASSIGN'
"<-"        return 'DECLARE'

/* for thunks and thunking */ 

"("         return 'OPEN'
")"         return 'CLOSE' 
"&"         return 'CONCAT'

/* for composition */ 
":"         return 'COMPOSE'
"@"         return 'ACOMPOS'
"%"         return 'HCOMPOS'
"|"         return 'FCOMPOS'
"*"         return 'TCOMPOS'

/* for forcing and values */
"!"         return 'FORCE'
"?"         return 'FORCEWITH'

/* for stack operations */
"_"         return 'POP'
"^"         return 'SWAP'
"~"         return 'DROP'
"#"         return 'DEPTH'

/* for I/O operations */
"<"         return 'IN'
">"         return 'OUT'

/* For introspection */
"$"         return 'STATE'

/* for strings and characters */
"\"         return 'ESCAPEC'
"'"         return 'SINGLEQ'
'"'         return 'DOUBLEQ'

/* for booleans */ 
"true"      return 'TRUE'
"false"     return 'FALSE'


<<EOF>>     return 'EOF'
            return 'INVALID'

/lex


/* standard stuff. Declarations are right-associative. */
%right 'WHEN' 'WHENEVER' 'BETWEEN' 'DECLARE'

/* the force-with operator, ?, does what the FORCE operator does, but takes an additional thunk as the RHS argument. This thunk specifies the intial symbol and stack context. I think (TODO confirm)
this means I want it right-associative, because it should be 'greedy' and absorb symbols until EOL */
%right 'FORCEWITH'

/* inline assignments, standard forcings, and concatenation are all left-associative */
%left  'ASSIGN'  'FORCE' 'CONCAT'

/* so are all stack and IO primitives */
%left  'POP' 'DROP' 'SWAP' 'DEPTH' 'IN' 'OUT'

/* so are composition operators, although TODO maybe add an operator like Haskell's $ which is highly useful*/
%left   'COMPOSE' 'ACOMPOS' 'HCOMPOS' 'FCOMPOS' 'TCOMPOS'

/* use new EBNF rules for Jison */ 
%ebnf 
%start code
%%


code              : statements* EOF
                           { typeof console !== 'undefined' ? console.log($1) : print($1) 
                             return $1 
                           } 
               
statement		   : declaration | thunk | forcing
           
declaration       : WHEN thunk DO thunk 
                  | thunk BETWEEN thunk DO thunk
                  | WHENEVER thunk DO thunk
                  | lvalue DECLARE rvalue 

lvalue			   : symbol
rvalue			   : thunk | forcing 

assignment   	   : lvalue ASSIGN rvalue

thunk				   :  OPEN expressions CLOSE
                  |  substatement CONCAT substatement
                  |  thunk compose thunk
                  |  symbol
               
               
compose           : COMPOSE | ACOMPOS | HCOMPOS | FCOMPOS | TCOMPOS 

substatement      : forcing | thunk | assignment

forcing				: thunk FORCE 
                  | thunk FORCEWITH thunk
                  | atom
                  | primitive 

primitive         : POP
                  | DROP
                  | SWAP
                  | DEPTH
                  | IN
                  | OUT
                  | STATE

atom              : boolean
                  | number
                  | string


symbol            : SYMBOL
boolean				: TRUE | FALSE
number				: UINT
string				: DOUBLEQ CHAR* DOUBLEQ
                  | SINGLEQ CHAR* SINGLEQ



%%
