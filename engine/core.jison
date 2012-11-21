/*************
   Hi-Script
   WTF Public License
   (c) 2012 Undoware
 *************/

/*
 *  ASSOCIATIVITY AND PRECEDENCE
 */

%right DECLARE
%left  IMPLY
%left  COMPOSE JUST_STACK JUST_SYMS FILTER REFLECT
%left  OUT DROP
%left  CONCAT
%left  ASSIGN 
%left  AS
%left  AND IOR XOR
%left  CONTAINS EQ NEQ GTE LTE GT LT 
%left  PLUS MINUS
%left  TIMES DIVIDES MODULO
%left  EXPONENT ROOT
%left  LN LOG
%left  NOT           
%left  FORCE FORCEWITH 
%left  IN SWAP DEPTH POP PEEK 


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
binary          : EQ | NEQ | LT | LTE | GT | GTE | AND | IOR | XOR | SWAP
                | PLUS | MINUS | TIMES | DIVIDES | LN | LOG | MODULO | ROOT | EXPONENT 
                | FORCEWITH | MEMBER | CONTAINS | AS

literal         : boolean | number | string 
string			 : Q  CHAR* Q | QQ CHAR* QQ
number			 : NUMBER | E | PI | GOLDEN | IMAGINARY | INFINITY
boolean			 : T | F

/*
 *   Thunks
 */

thunk			     : symbol | declaration | composition | thunk_literal
symbol           : SYMBOL | ELLIPSIS | GESTALT /* last 2 cannot be assigned to */ 
declaration      : SYMBOL (ASSIGN|DECLARE) (expr?)

composition      : (thunk?) composer thunk  | composer (thunk?) 
composer         : IMPLY | COMPOSE | CONCAT | JUST_STACK | JUST_SYMS | FILTER | REFLECT

thunk_literal    : object | array | closure | EMPTY
object           : LBRCE (expr  COLON expr ((COMMA expr COLON expr)*))? RBRCE 
array            : LBRKT  expr (COMMA expr)* RBRKT
closure          : LPARN  expr* RPARN

/* EOF */
%%
