/*************
   Hi-Script
   WTF Public License
   (c) 2013 Undoware
 *************/

/*
 *  PROLOGUE
 */

%{
   var hi   = require("hi"),
       old  = [],
       swp  = {};
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
%left            KIN GOT EQ NEQ GTE LTE GT LT
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
line            : expr delimiter*      -> hi($expr)
expr            : forcing | thunk

/*
 *   Forcings
 */
/* TODO cleanup */
forcing         : operator | literal

operator        : unary (expr?)           -> $unary($expr)
                | (expr?) binary (expr?)  -> $binary($expr1,$expr2)
unary           : FORCE       -> hi.force
                | FORCEALL    -> hi.forcer
                | RECV        -> hi.recv
                | SEND        -> hi.send
                | DEPTH       -> hi.stack.depth
                | POP         -> hi.stack.pop
                | PEEK        -> hi.stack.peek
                | DROP        -> hi.stack.drop
                | NOT         -> hi.logic.n
binary          : EQ          -> hi.check.eq
                | NEQ         -> hi.check.neq
                | LT          -> hi.check.lt
                | LTE         -> hi.check.lte
                | GT          -> hi.check.gt
                | GTE         -> hi.check.gte
                | GOT         -> hi.check.got
                | AND         -> hi.logic.a
                | IOR         -> hi.logic.o
                | XOR         -> hi.logic.x
                | KIN         -> hi.check.kin
                | LIKE        -> hi.check.like
                | SWAP        -> hi.stack.swap
                | PLUS        -> hi.math.plus
                | MINUS       -> hi.math.minus
                | TIMES       -> hi.math.times
                | DIVIDES     -> hi.math.div
                | POW         -> hi.math.pow
                | ROOT        -> hi.math.root
                | LOG         -> hi.math.log
                | LN          -> hi.math.ln
                | MODULO      -> hi.math.mod
                | JUST_MEMBER -> hi.just.member
                | FORCEWITH   -> function(x,y) { return hi.compose(y,x); }  /* recall x?y == y:x */

literal         : number | boolean | string
number          : '-' number %prec UMINUS -> hi.math.uminus($2)
                | CONSTANT -> hi(hi.core.constant[$1])
                | NUMBER   -> hi($1)
boolean         : BOOLEAN  -> hi($1)
string          : STRING   -> hi($1)


/*
 *   Thunks
 */

thunk           : symbol | declaration | composition | thunk_literal
symbol          : LVALUE   -> hi.sym[$1]
                | GESTALT  -> hi

/* remember ASSIGN and DECLARE differ only in that DECLARE is right associative */
declaration     : LVALUE (ASSIGN|DECLARE) (expr?) -> hi.sym[$1] = (!!$3) ? hi.sym[$1] : {};

composition     : (thunk?) composer thunk -> $composer($1,$3)
                | composer (thunk?)       -> $composer($2)

composer        : COMPOSE    -> hi.compose
                | IMPLY      -> hi.imply
                | GLUE       -> hi.glue
                | REFLECT    -> hi.reflect
                | JUST_STACK -> hi.just.syms
                | JUST_SYMS  -> hi.just.stack
                | FILTER     -> hi.just

thunk_literal   : object | array | closure
object          : LBRCE (kvpair ((COMMA kvpair)*))? RBRCE           -> hi.apply({ sym: { $kvpair, $kvpair } });
kvpair          : expr COLON expr
array           : LBRKT  expr (COMMA expr)* RBRKT                   -> hi.apply({ stack: [$expr1,$expr2] });
closure         : empty-cl | inline-cl | multiline-cl
empty-cl        : ( LPARN RPARN | EMPTY )                                      -> hi.apply({});
inline-cl       : LPARN  expr+ RPARN                                           -> hi.apply( { queue: [$expr] } );
multiline-cl    : LPARN expr*                                                  -> hi = hi.hi( { queue: [$expr] } );
                | expr* RPARN                                                  -> hi = hi.bye({ queue: [$expr] } );



/* EOF */
%%
