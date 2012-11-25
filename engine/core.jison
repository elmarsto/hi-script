/*************
   Hi-Script
   WTF Public License
   (c) 2012 Undoware
 *************/

/*
 *  PROLOGUE
 */

%{
   var core = require 'core',
   hi = core.make(),
   logic = hi.logic,/*and, both ors*/
   io    = hi.io,   /*io.stack*/
   make  = hi.make, /*generators*/
   stack = hi.stack,/*stack*/
   sym   = hi.sym,  /*symbol table*/
   trans = hi.trans;/*transforms*/
%}


/*
 *  ASSOCIATIVITY AND PRECEDENCE
 */

%right DECLARE
%left  IMPLY
%left  COMPOSE JUST_STACK JUST_SYMS FILTER REFLECT
%left  OUT DROP
%left  GLUE
%left  ASSIGN 
%left  LIKE
%left  AND IOR XOR
%left  KIN CONTAINS EQ NEQ GTE LTE GT LT 
%left  PLUS MINUS
%left  TIMES DIVIDES MODULO
%left  POW ROOT
%left  LN LOG
%left  NOT           
%left  FORCE FORCEWITH 
%left  IN SWAP DEPTH POP PEEK JUST_MEMBER
%left  UMINUS


/*
 *  GRAMMAR
 */


%ebnf 
%%

input            : input line | input EOF
line             : (expr?) delimiter
expr             : forcing -> hi($1())
                 | thunk   -> hi($1)

/*
 *   Forcings
 */

forcing			 : operator | literal

operator        : unary (expr?)           -> trans($unary,$expr)
                | (expr?) binary (expr?)  -> trans($binary,$expr1,$expr2)
unary           : NOT         -> logic.n
                | DEPTH       -> stack.depth
                | POP         -> stack.pop
                | PEEK        -> stack.peek
                | DROP        -> stack.drop
                | IN          -> function() { return stack.push(io.pull()); }
                | OUT         -> function() { return io.push(stack.pop());  }
                | FORCE       -> function() { return x; } /* identity function (operator semantics already imply forcing) */
binary          : FORCEWITH   -> function(x,y) { return trans.compose(y,x); }  /* recall x?y == y:x */
                | EQ          -> logic.eq
                | NEQ         -> logic.neq
                | LT          -> logic.lt
                | LTE         -> logic.lte
                | GT          -> logic.gt
                | GTE         -> logic.gte
                | CONTAINS    -> logic.contains
                | AND         -> logic.a
                | IOR         -> logic.o
                | XOR         -> logic.x
                | SWAP        -> trans.swap
                | PLUS        -> trans.math.plus
                | MINUS       -> trans.math.minus
                | TIMES       -> trans.math.times
                | DIVIDES     -> trans.math.div
                | LN          -> trans.math.ln
                | LOG         -> trans.math.log
                | MODULO      -> trans.math.mod
                | ROOT        -> trans.math.root
                | POW         -> trans.math.pow
                | JUST_MEMBER -> trans.just.member
                | LIKE        -> trans.like
                | KIN         -> logic.kin

literal         : number | boolean | string 
number			 : '-' number %prec UMINUS -> trans.uminus($2) 
                | CONSTANT -> core.constant($1)
                | NUMBER   -> make.number($1)
boolean			 : BOOLEAN  -> make.bool($1)
string			 : STRING   -> make.string($1)
/*
 *   Thunks
 */

thunk			     : symbol | declaration | composition | thunk_literal
symbol           : LVALUE   -> sym($1)
                 | ELLIPSIS -> stack
                 | GESTALT  -> hi
declaration      : LVALUE (ASSIGN|DECLARE) (expr?) -> sym($1,$3)

composition      : (thunk?) composer thunk -> trans($2,$1,$3)
                 | composer (thunk?)       -> trans($1,$2)
composer         : IMPLY      -> trans.compose.imply
                 | COMPOSE    -> trans.compose
                 | GLUE       -> trans.compose.glue
                 | JUST_STACK -> trans.just.syms
                 | JUST_SYMS  -> trans.just.stack
                 | FILTER     -> trans.just
                 | REFLECT    -> trans.compose.reflect //TODO reorg and cleanup
                 | 

thunk_literal    : object | array | closure | EMPTY
object           : LBRCE (expr  COLON expr ((COMMA expr COLON expr)*))? RBRCE   -> make.object($expr1,$expr2,$expr3,$expr4)
array            : LBRKT  expr (COMMA expr)* RBRKT                              -> make.array($expr1,$expr2)
closure          : LPARN  expr* RPARN                                           -> make($expr)



/* EOF */
%%
