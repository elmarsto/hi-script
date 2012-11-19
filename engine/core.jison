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

%%

\s+          /* skip whitespace */
"---"\b.*    /* ignore inline comment */
             /*  TODO add multiline comments with /^---$/ for both open and close */

[\n;]+      return 'DELIMITER'


/* numbers */ 
("-"?)({DCNZ}({DECA}*)|"0"+)\b             return 'INT'
("-"?)({DCNZ}({DECA}*)|"0"+)"."({DECA}+)\b return 'FLOAT' /*TODO scientific notation*/

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
"{}"        return 'JSON_EMPTY'
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
%left  'ASSIGN' 'FORCE'
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
code             : statement* EOF
                           { typeof console !== 'undefined' ? console.log($1) : print($1) 
                             return $1 
                           } 
statement        : expr (DELIMITER?)
expr             : thunk | forcing 
thunk				  : declaration | composition | symbol | json 
declaration      : modal | assignment
assignment       : symbol assgn expr
                 | assign expr
                 | assign
assign           : ASSIGN | DECLARE
modal            : when expr DO thunk
                 | when DO thunk
                 | when DO 
when             : WHEN | WHENEVER | BETWEEN                 
composition      : thunk comp thunk
                 | comp thunk
                 | comp
comp             : COMPOSE | CONCAT | MKARRAY | MKHASH | FILTER | REFLECT 
forcing			  : thunk FORCE
                 | FORCE
                 | thunk FORCEWITH expr
                 | FORCEWITH expr
                 | FORCEWITH
                 | access
                 | atom
                 | operator
operator         : unor | binor | n_or   /* 'un' 'o(perato)r' = unor , etc. */
unor             : unary
unary            : DEPTH                 /* (as integer) current depth of the stack */ 
                 | GESTALT               /* special value represents current monad */ 
                 | POP  
                 | PEEK
                 | DROP
                 | IN 
                 | OUT
binor            : expr binary expr
                 | expr binary 
                 | binary
binary           : SWAP                  /* any others? TODO think about it */
n_or             : expr* n_ary
n_ary            : PLUS | MINUS | TIMES | DVDBY
atom             : boolean
                 | number
                 | string
symbol           : SYMWORD 
boolean			  : T | F
number			  : INT | FLOAT
string			  : Q  CHAR* Q
                 | QQ CHAR* QQ
json             : JSON_LBRKT expr (JSON_COMMA expr)* JSON_RBRKT
                 | JSON_LBRCE pair (JSON_COMMA pair)* JSON_RBRCE
                 | empty

empty            : JSON_LBRCE JSON_RBRCE
                 | JSON_EMPTY

pair             : (string | thunk) JSON_COLON expr /* the thunk must produce a
                                                   valid JSON object key, or 
                                                   runtime exception occurs */

access           : thunk JSON_DOT   expr /* forced computation must return a valid symbol */
                 | thunk JSON_LBRKT expr JSON_RBRKT /* ditto, but s/symbol/integer  */
%%
