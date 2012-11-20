/*******************************************************
 *  Hi-Script -- core language    
 *******************************************************/ 

%right 'WHEN' 'WHENEVER' 'BETWEEN' 'DECLARE' 'FORCEWITH'
%left  'AND' 'IOR' 'XOR' 'PLUS' 'MINUS' 'TIMES' 'DVDBY' 
%left  'SWAP' 'ASSIGN' 'COMPOSE' 'CONCAT' 'MKARRAY' 'MKOBJ' 'FILTER' 'REFLECT' 'DOT' 'COLON'
%ebnf 
%start code
%%
input            : input line 
line             (expr?) delimiter                
expr             : thunk | forcing 

/*
 * THUNKS
 */

thunk			 : SYMBOL | declaration | composition | object | array | closure

/* attach a thunk to an event or a symbol */
declaration      : SYMBOL (ASSIGN|DECLARE) (expr?) (WHEN | WHENEVER | BETWEEN) (expr?) DO (thunk?)

/* note that these aren't technically 'operators', which in hi-script implies a force */
composition      : (thunk?) comp thunk | comp (thunk?) | idx_into_array 
comp             : COMPOSE | CONCAT | MKARRAY | MKOBJ | FILTER | REFLECT | DOT
idx_into_array   : (thunk?) LBRKT (expr?) RBRKT 

/* these are all different ways of expressing a thunk literal */
object           : LBRCE (expr  COLON expr ((COMMA expr COLON expr)*))? RBRCE | EMPTY
array            : LBRKT  expr (COMMA expr)* RBRKT
closure          : LPARN  expr* RPARN

/*
 * FORCINGS
 */
forcing			  : atom | operator

operator         : unary | (expr?) binary (expr?)
unary            : NOT | DEPTH | GESTALT | POP | PEEK | DROP | IN | OUT | FORCE
binary           : AND | IOR | XOR | SWAP | PLUS | MINUS | TIMES | DVDBY | FORCEWITH

atom             : boolean | number | string
string			 : Q  CHAR* Q | QQ CHAR* QQ
number			 : INT | FLOAT
boolean			 : T | F
%%
