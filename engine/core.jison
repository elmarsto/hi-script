/*******************************************************
 *  Hi-Script -- core language      			     			   * 
 *******************************************************/ 

%lex

/* numbers */
DECA        [1-9]([0-9]*)

/*TODO Clean this up? How to refer to previously declared groups from with in the regex? */
/*Basically, a symbol can be any nonzero-length utf-8 character string, but it can't contain a reserved symbol and it can't start with a number, a /, or a - */
SYM         [^.,;:/0123456789\\^_~!@#$%^&*()<>|?!"`'=-]([^.,;:\\^_~!@#$%^&*()<>|?!"`'=]*)

/* The same thing, but for JSON object literal bare key names */ 
JSYM    [A-Za-z0-9_-]+

%%
{DECA}      return 'UINT'     /* positive integer */
{SYM}       return 'SYMWORD'  /* symbol-word, i.e. a potential lvalue */


\s+        /* skip whitespace */
"--- ".*   /* ignore inline comment */
           /*  TODO add multiline comments with /^---$/ for both open and close */



/* for declarations */
"when"      return 'WHEN'
"whenever"  return 'WHENEVER'
"between"   return 'BETWEEN'
"->"        return 'DO'
"<-"        return 'DECLARE' /* semantically the same as ASSIGN, 
                                but with higher precedence, and 
                                syntax is right-associative; 
                                i.e. 'x <- y=0 & z' means 'x = (y=0 & Z)' */
"="         return 'ASSIGN'  /* for inline assignments, e.g. in thunk declarations */

/* for thunks and thunking */ 
"("         return 'OPEN'
")"         return 'CLOSE' 
"&"         return 'CONCAT'

/* for composition */ 
":"         return 'COMPOSE'
"@"         return 'ASARRAY'
"%"         return 'ASHASH'
"|"         return 'FILTER'
"><"        return 'REFLECT'

/* for forcing and values */
"!"         return 'FORCE'
"?"         return 'FORCEWITH'

/* for arithmetic */ 

"+"         return 'PLUS'
"-"         return 'MINUS'
"*"         return 'TIMES'
"/"         return 'DIVDBY'

/* for stack operations */
"_"         return 'POP'  
"__"        return 'PEEK' /* nm. 'copy the popped value and push it back on the stack' */ 
"^"         return 'SWAP' /* least-surprise lawful */
"~"         return 'DROP' /* least-surprise lawful */

/* 
   recall that mentioning any symbol or thunk, 
   or unthunking a computation that results in a value,
   all imply a push; thus there is no push operator
*/ 


/* for I/O operations */
"<"         return 'IN'       /* pop stdin, push to stack */
">"         return 'OUT'      /* pop stack, push to stdout */

/* For introspection */
"$"         return 'GESTALT' /* current thunk */
"#"         return 'DEPTH'   /* current stack depth (UINT) */ 


/* for strings and characters */
"'"         return 'Q'
'"'         return 'QQ'

/* for booleans */ 
"true"      return 'T'
"false"     return 'F'

/* JSON support */

{JSYM}      return 'JSON_SYMBL' /* a valid identifier for a JSON object (hash) */
"["         return 'JSON_LBRKT'
"]"         return 'JSON_RBRKT'
"{"         return 'JSON_LBRCE'
"}"         return 'JSON_RBRCE'
":"         return 'JSON_COLON'
","         return 'JSON_COMMA'


/* edge conditions */ 
<<EOF>>     return 'EOF'
            return 'INVALID'

/lex


/* standard stuff. Declarations are right-associative. */
%right 'WHEN' 'WHENEVER' 'BETWEEN' 'DECLARE'

/* the force-with operator, ?, does what the FORCE operator does, but takes an additional thunk as the RHS argument. */
%right 'FORCEWITH'

/* inline assignments, standard forcings, and concatenation are all left-associative */
%left  'ASSIGN'  'FORCE' 'CONCAT'

/* so are all arithmetic, stack and IO primitives */
%left  'PLUS' 'MINUS' 'TIMES' 'DVDBY' 'POP' 'PEEK' 'DROP' 'SWAP' 'DEPTH' 'IN' 'OUT'

/* so are composition operators, although TODO maybe add an operator like Haskell's $ which is highly useful*/
%left   'COMPOSE' 'ASARRAY' 'ASHASH' 'FILTER' 'REFLECT'

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
                  |  json


json              : JSON_LBRKT json      (JSON_COMMA json     )* JSON_RBRKT
                  | JSON_LBRCE json_pair (JSON_COMMA json_pair)* JSON_RBRCE
                  | atom   /* conveniently, hi-script shares atomic types with JSON */
                  | thunk  /* monads can be sent out the door as JSON, because that's what they are internally! holy introspection batgirl */ 

json_pair         : json_key JSON_COLON json /* the thunk must produce a valid JSON object key, or runtime exception occurs */

json_key          : string
                  | thunk
                  | JSON_SYMBL
               
compose           : COMPOSE | ARRAY | HASH | FILTER | REFLECT

substatement      : forcing | thunk | assignment

forcing				: thunk FORCE 
                  | thunk FORCEWITH thunk
                  | atom
                  | primitive 

primitive         : PLUS      /* arithmetic */
                  | MINUS
                  | TIMES
                  | DVDBY
                  | POP       /* stack */
                  | DROP
                  | SWAP
                  | DEPTH
                  | IN        /* I/O */
                  | OUT
                  | GESTALT   /* introspection */

atom              : boolean
                  | number
                  | string


symbol            : SYMWORD 
boolean				: T | F
number				: UINT /* TODO floats, negative integers */ 
string				: Q  CHAR* Q
                  | QQ CHAR* QQ

%%
