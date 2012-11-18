/*******************************************************
 *  Hi-Script -- core language      			     			   * 
 *******************************************************/ 

%lex

/* numbers */
DECA  [0-9]
DCNZ  [1-9]


/* TODO DRY this mess up. Is it permissible refer to previously declared groups from with
 * in the range section? TODO research */

SYM1  [^.,;:/\d\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]-]
SYMN  [^,;:\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]]

/* The same thing, but for JSON object literal bare key names */ 
JSYM  [A-Za-z0-9_-\s]+

%%

\s+          /* skip whitespace */
"---"\b.*    /* ignore inline comment */
             /*  TODO add multiline comments with /^---$/ for both open and close */

[\n;]+      return 'DELIMITER'


/* numbers */ 
("-"?)({DCNZ}({DECA}*)|"0"+)\b             return "INT"
("-"?)({DCNZ}({DECA}*)|"0"+)"."({DECA}+)\b return "FLOAT" /*TODO scientific notation*/

/* symbols */ 
{SYM1}({SYMN}*)\b return 'SYMWORD'                          /* symbol-word= a potential lvalue */
{JSYM}\b          return 'JSON_SYMBL'                       /* a valid bare key literal */


/* declarations */
"when"      return 'WHEN'
"whenever"  return 'WHENEVER'
"between"   return 'BETWEEN'
"->"        return 'DO'
"="         return 'ASSIGN'  /* for inline declarations, e.g. in thunks specified with CONCAT  */
"<-"        return 'DECLARE' /* semantically the same as ASSIGN, 
                                but with higher precedence, and 
                                syntax is right-associative; 
                                i.e. 'x <- y=0 & z' means 'x = (y=0 & Z)' */

/* thunks and thunking */ 
"("         return 'OPEN'
")"         return 'CLOSE' 

/* composition */ 
":"         return 'COMPOSE'
"&"         return 'CONCAT'
"@"         return 'MKARRAY'
"%"         return 'MKHASH'
"|"         return 'FILTER'
"><"        return 'REFLECT'

/* forcing and values */
"!"         return 'FORCE'
"?"         return 'FORCEWITH'

/* For introspection */
"$"         return 'GESTALT' /* current thunk */
"#"         return 'DEPTH'   /* current stack depth (UINT) */ 

/* arithmetic */ 

"+"         return 'PLUS'
"-"         return 'MINUS'
"*"         return 'TIMES'
"/"         return 'DIVDBY'

/* stack operations */
"_"         return 'POP'  
"__"        return 'PEEK' /* also could be called DUP (duplicate then pop) */ 
"^"         return 'SWAP' /* least-surprise lawful */
"~"         return 'DROP' /* least-surprise lawful */

/* 
   recall that mentioning any symbol or thunk, 
   or unthunking a computation that results in a value,
   all imply a push; thus there is no push operator
*/ 


/* I/O operations */
"<"         return 'IN'       /* pop stdin, push to stack */
">"         return 'OUT'      /* pop stack, push to stdout */



/* strings and characters */
"'"         return 'Q'
'"'         return 'QQ'

/* booleans */ 
"true"      return 'T'
"false"     return 'F'

/* JSON support */

"["         return 'JSON_LBRKT'
"]"         return 'JSON_RBRKT'
"{"         return 'JSON_LBRCE'
"}"         return 'JSON_RBRCE'
":"         return 'JSON_COLON'
","         return 'JSON_COMMA'
"."         return 'JSON_DOT'

/* edge conditions */ 
<<EOF>>     return 'EOF'
            return 'INVALID'

/lex


/* standard stuff. Declarations are right-associative. */
%right 'WHEN' 'WHENEVER' 'BETWEEN' 'DECLARE'

/* the force-with operator, ?, does what the FORCE operator does, but takes an
 * additional thunk as the RHS argument. */
%right 'FORCEWITH'

/* inline assignments, standard forcings, and concatenation are all
 * left-associative */
%left  'ASSIGN'  'FORCE'

/* so are all arithmetic, stack and IO primitives */
%left  'PLUS' 'MINUS' 'TIMES' 'DVDBY' 'POP' 'PEEK' 'DROP' 'SWAP' 'IN' 'OUT'

/* JSON member access*/
%left  'JSON_DOT'
/* JSON key/value declaration  */
%right 'JSON_COLON'

/* so are composition operators, although TODO maybe add an operator like
 * Haskell's $ which is highly useful*/
%left  'COMPOSE' 'CONCAT' 'MKARRAY' 'MKHASH' 'FILTER' 'REFLECT'


/* use new EBNF rules for Jison */ 
%ebnf 
%start code
%%


code             : expr* EOF
                           { typeof console !== 'undefined' ? console.log($1) : print($1) 
                             return $1 
                           } 
              

expr             : thunk | forcing 

/* a closure, aka monad, aka computation-type */
thunk				  :  declaration
                 |  composition
                 |  symbol
                 |  json

declaration      : WHEN thunk DO thunk 
                 | WHENEVER thunk DO thunk
                 | thunk BETWEEN thunk DO thunk
                 | symbol DECLARE expr
                 | symbol ASSIGN  expr
               
composition:     : thunk COMPOSE thunk
                 | thunk CONCAT  thunk
                 | thunk MKARRAY thunk
                 | thunk MKHASH  thunk
                 | thunk FILTER  thunk
                 | thunk REFLECT thunk

forcing			  : thunk FORCE
                 | thunk FORCEWITH thunk
                 | json_elt_access
                 | atom
                 | operator

operator         : unary
                 | forcing forcing (binary?)
                 | forcing* n_ary

unary            : DEPTH                 /* (as integer) current depth of the stack */ 
                 | GESTALT               /* special value represents current monad */ 

binary           : SWAP                  /* any others? TODO think about it */

/* these can take an arbitrary number of arguments */
n_ary            : actual_n_ary | convenience_n_ary
actual_n_ary     : arithmetic
arithmetic       : PLUS | MINUS | TIMES | DVDBY
convenience_n_ary: stack | io
stack            : POP | PEEK | DROP  
io               : IN | OUT

atom             : boolean
                 | number
                 | string
symbol           : SYMWORD 
boolean			  : T | F
number			  : INT | FLOAT
string			  : Q  CHAR* Q
                 | QQ CHAR* QQ

/* JSON compatibility */ 
json              : JSON_LBRKT json_val  (JSON_COMMA json_val )* JSON_RBRKT
                  | JSON_LBRCE json_pair (JSON_COMMA json_pair)* JSON_RBRCE
json_pair         : json_key JSON_COLON json_elt /* the thunk must produce a
                                                    valid JSON object key, or 
                                                    runtime exception occurs */
json_key          : string      /* 'any' "utf-8 string" 'will do' */
                  | forcing     /* must return valid JSON_SYMBL else runtime error */
                  | JSON_SYMBL 
json_val          : json | expr
json_elt_access   : thunk JSON_DOT   forcing  /* forced computation must return a valid symbol */
                  | thunk JSON_LBRKT forcing JSON_RBRKT /* ditto, but s/symbol/integer  */
%%
