/*************
   Hi-Script
   WTF Public License
   (c) 2012 Undoware
 *************/

/*
 *  PROLOGUE
 */

%{
   var core =   require 'core',
       hi   =   core.hi();
%}


/*
 *  ASSOCIATIVITY AND PRECEDENCE
 */

%right           DECLARE
%left            IMPLY
%left            COMPOSE JUST_STACK JUST_SYMS FILTER REFLECT
%left            OUT DROP
%left            GLUE
%left            ASSIGN 
%left            LIKE
%left            AND IOR XOR
%left            KIN CONTAINS EQ NEQ GTE LTE GT LT 
%left            PLUS MINUS
%left            TIMES DIVIDES MODULO
%left            POW ROOT
%left            LN LOG
%left            NOT           
%left            FORCE FORCEWITH 
%left            IN SWAP DEPTH POP PEEK JUST_MEMBER
%left            UMINUS


/*
 *  GRAMMAR
 */


%ebnf 
%%

input           : input line | input EOF
line            : (expr?) delimiter
expr            : forcing -> hi($1())
                | thunk   -> hi($1)

/*
 *   Forcings
 */

forcing         : operator | literal

operator        : unary (expr?)           -> hi.trans($unary,$expr)
                | (expr?) binary (expr?)  -> hi.trans($binary,$expr1,$expr2)
unary           : FORCE       -> function() { return x; }                       /* identity function (operator semantics already imply forcing) */
                | IN          -> function() { return hi.stack.push(hi.io.pull()); }
                | OUT         -> function() { return hi.io.push(hi.stack.pop());  }
                | DEPTH       -> hi.stack.depth
                | POP         -> hi.stack.pop
                | PEEK        -> hi.stack.peek
                | DROP        -> hi.stack.drop
                | NOT         -> hi.logic.n
binary          : EQ          -> hi.logic.eq
                | NEQ         -> hi.logic.neq
                | LT          -> hi.logic.lt
                | LTE         -> hi.logic.lte
                | GT          -> hi.logic.gt
                | GTE         -> hi.logic.gte
                | CONTAINS    -> hi.logic.contains
                | AND         -> hi.logic.a
                | IOR         -> hi.logic.o
                | XOR         -> hi.logic.x
                | KIN         -> hi.logic.kin
                | LIKE        -> hi.trans.like
                | SWAP        -> hi.trans.swap
                | PLUS        -> hi.trans.math.plus
                | MINUS       -> hi.trans.math.minus
                | TIMES       -> hi.trans.math.times
                | DIVIDES     -> hi.trans.math.div
                | POW         -> hi.trans.math.pow
                | ROOT        -> hi.trans.math.root
                | LOG         -> hi.trans.math.log
                | LN          -> hi.trans.math.ln
                | MODULO      -> hi.trans.math.mod
                | JUST_MEMBER -> hi.trans.just.member 
                | FORCEWITH   -> function(x,y) { return hi.trans.compose(y,x); }  /* recall x?y == y:x */
               

literal         : number | boolean | string 
number          : '-' number %prec UMINUS -> hi.trans.uminus($2) 
                | CONSTANT -> hi.core.constant($1)
                | NUMBER   -> hi.make.number($1)
boolean         : BOOLEAN  -> hi.make.bool($1)
string          : STRING   -> hi.make.string($1)


/*
 *   Thunks
 */

thunk           : symbol | declaration | composition | thunk_literal
symbol          : LVALUE   -> hi.sym($1)
                | ELLIPSIS -> hi.stack
                | GESTALT  -> hi

declaration     : LVALUE (ASSIGN|DECLARE) (expr?) -> hi.sym($1,$3)

composition     : (thunk?) composer thunk -> hi.trans($2,$1,$3)
                | composer (thunk?)       -> hi.trans($1,$2)
composer        : COMPOSE    -> hi.trans.compose
                | IMPLY      -> hi.trans.compose.imply
                | GLUE       -> hi.trans.compose.glue
                | REFLECT    -> hi.trans.compose.reflect 
                | JUST_STACK -> hi.trans.just.syms
                | JUST_SYMS  -> hi.trans.just.stack
                | FILTER     -> hi.trans.just

thunk_literal   : object | array | closure 
object          : LBRCE (expr  COLON expr ((COMMA expr COLON expr)*))? RBRCE   -> hi.make.object($expr1,$expr2,$expr3,$expr4)
array           : LBRKT  expr (COMMA expr)* RBRKT                              -> hi.make.array($expr1,$expr2)
closure         : empty-cl | inline-cl | multiline-cl
empty-cl        : ( LPARN RPARN | EMPTY )                                      -> hi.make()
inline-cl       : LPARN  expr+ RPARN                                           -> hi.make($expr)
multiline-cl    : LPARN expr*                                                  -> core.hi(hi.make($expr)); hi = core.hi()
                | expr* RPARN                                                  -> hi.bye();                hi = core.hi()



/* EOF */
%%
