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
   hi = core.monad.make(),
   logic = hi.logic,/*and, both ors*/
   io    = hi.io,   /*io.stack*/
   make  = hi.make, /*generators*/
   math  = hi.math, /*arithmetic*/ 
   stack = hi.stack,/*stack*/
   sym   = hi.sym,  /*symbol table*/
   trans = hi.trans,/*transforms*/
   test  = hi.test; /*equality, membership, magnitude...*/
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
%left  CONTAINS EQ NEQ GTE LTE GT LT 
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
expr             : forcing -> stack.push($1())
                 | thunk   -> stack.push($1)

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
                | EQ          -> test.eq
                | NEQ         -> test.neq
                | LT          -> test.lt
                | LTE         -> test.lte
                | GT          -> test.gt
                | GTE         -> test.gte
                | CONTAINS    -> test.contains
                | AND         -> logic.a
                | IOR         -> logic.o
                | XOR         -> logic.x
                | SWAP        -> stack.swap
                | PLUS        -> math.plus
                | MINUS       -> math.minus
                | TIMES       -> math.times
                | DIVIDES     -> math.divides
                | LN          -> math.ln
                | LOG         -> math.log
                | MODULO      -> math.modulo
                | ROOT        -> math.root
                | POW         -> math.pow
                | JUST_MEMBER -> trans.member
                | LIKE        -> trans.like

literal         : number | boolean | string 
number			 : '-' number %prec UMINUS -> trans.uminus($2) 
                | CONSTANT -> make.constant($1)
                | NUMBER   -> make.number($1)
boolean			 : (T|F)    -> make.boolean($1)
string			 : STRING   -> make.string($1)
/*
 *   Thunks
 */

thunk			     : symbol | declaration | composition | thunk_literal
symbol           : LVALUE   -> sym($1)
                 | ELLIPSIS -> sym.lipsis
                 | GESTALT  -> sym.gestalt
declaration      : LVALUE (ASSIGN|DECLARE) (expr?) -> sym($1,$3)

composition      : (thunk?) composer thunk -> $2($1,$3)
                 | composer (thunk?) -> $1($2)
composer         : IMPLY      -> trans.imply
                 | COMPOSE    -> trans.compose
                 | GLUE       -> trans.glue
                 | JUST_STACK -> trans.syms
                 | JUST_SYMS  -> trans.stack
                 | FILTER     -> trans.filter
                 | REFLECT    -> trans.reflect

thunk_literal    : object | array | closure | EMPTY
object           : LBRCE (expr  COLON expr ((COMMA expr COLON expr)*))? RBRCE   -> make.object($expr1,$expr2,$expr3,$expr4)
array            : LBRKT  expr (COMMA expr)* RBRKT                              -> make.array($expr1,$expr2)
closure          : LPARN  expr* RPARN                                           -> make($expr)



/* EOF */
%%D
