/*************
   Hi-Script
   WTF Public License
   (c) 2012 Undoware
 *************/

/*
 *  PRELIMINARIES
 */

/* Associativity for thunk declarations and compositions */
%right 'DECLARE' 
%left  'ASSIGN' 'IMPLY' 'COMPOSE' 'CONCAT' 'MKARRAY' 'MKOBJ' 'FILTER' 'REFLECT' 'MEMBER' 'ISMEMBER'

/* Associativity for binary forcing operators */ 
%right 'FORCEWITH'
%left  'AND' 'IOR' 'XOR' 'PLUS' 'MINUS' 'TIMES' 'DVDBY' 'EQUALS' 'NEQUALS' 'GTE' 'LTE' 'GT' 'LT' 'SWAP'


/*
 *  GRAMMAR
 *
 */

%ebnf 
%%

input            : input line 
line             : (expr?) delimiter                
expr             : thunk | forcing 

/*
 *   Thunks
 */

thunk			 : SYMBOL | declaration | composition | thunk_literal

declaration      : SYMBOL (ASSIGN|DECLARE) (expr?)

composition      : (thunk?) composer thunk | composer (thunk?) 

composer         : IMPLY | COMPOSE | CONCAT | MKARRAY | MKOBJ | FILTER | REFLECT | MEMBER | ISMEMBER

thunk_literal    : object | array | closure | EMPTY
object           : LBRCE (expr  COLON expr ((COMMA expr COLON expr)*))? RBRCE 
array            : LBRKT  expr (COMMA expr)* RBRKT
closure          : LPARN  expr* RPARN

/*
 *   Forcings
 */

forcing			 : operator | literal

operator         : unary | (expr?) binary (expr?)
unary            : NOT | DEPTH | GESTALT | POP | PEEK | DROP | IN | OUT | FORCE
binary           : EQUALS | NEQUALS | LT | LTE | GT | GTE | AND | IOR | XOR | SWAP
                 | PLUS | MINUS | TIMES | DVDBY | FORCEWITH 

literal          : boolean | number | string
string			 : Q  CHAR* Q | QQ CHAR* QQ
number			 : INT | FLOAT
boolean			 : T | F

/* EOF */
%%
