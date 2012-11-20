/*************
   Hi-Script
   WTF Public License
   (c) 2012 Undoware
 *************/

/*
 *  ASSOCIATIVITY AND PRECEDENCE
 */

%right DECLARE 
%left  IN OUT DROP
%left  IMPLY COMPOSE CONCAT MKARRAY MKOBJ FILTER REFLECT
%left  NOT AND IOR XOR
%left  ISMEMBER EQUALS NEQUALS GTE LTE GT LT 
%left  PLUS MINUS
%left  TIMES DVDBY
%left  POP PEEK SWAP
%left  MEMBER ASSIGN DEPTH
%left  FORCE FORCEWITH



/*
 *  GRAMMAR
 */

%ebnf 
%%

input            : input line 
line             : (expr?) delimiter                
expr             : forcing | thunk 

/*
 *   Forcings
 */

forcing			 : operator | literal

operator        : unary | (expr?) binary (expr?)
unary           : NOT | DEPTH | POP | PEEK | DROP | IN | OUT | FORCE
binary          : EQUALS | NEQUALS | LT | LTE | GT | GTE | AND | IOR | XOR | SWAP
                | PLUS | MINUS | TIMES | DVDBY | FORCEWITH | MEMBER | ISMEMBER

literal         : boolean | number | string | constant
string			 : Q  CHAR* Q | QQ CHAR* QQ
number			 : INT | FLOAT
boolean			 : T | F
constant        : E | PI  

/*
 *   Thunks
 */

thunk			     : lvalue | special | declaration | composition | thunk_literal
lvalue           : SYMBOL
special          : ELLIPSIS | GESTALT

declaration      : lvalue (ASSIGN|DECLARE) (expr?)

composition      : (thunk?) composer thunk  | composer (thunk?) 
composer         : IMPLY | COMPOSE | CONCAT | MKARRAY | MKOBJ | FILTER | REFLECT

thunk_literal    : object | array | closure | EMPTY
object           : LBRCE (expr  COLON expr ((COMMA expr COLON expr)*))? RBRCE 
array            : LBRKT  expr (COMMA expr)* RBRKT
closure          : LPARN  expr* RPARN

/* EOF */
%%
