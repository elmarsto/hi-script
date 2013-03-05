/************
   Hi-Script
   WTF Public License
   (c) 2013 Undoware
 *************/

/*
 *  PROLOGUE
 */

%{
//   var hi   = require("hi"),
//       old  = [],
//       swp  = {};
%}


/*
 *  ASSOCIATIVITY AND PRECEDENCE
 */

//%right           DECLARE
//%left            IMPLY
//%left            COMPOSE JUST_STACK JUST_SYMS FILTER REFLECT
//%left            OUT DROP
//%left            GLUE
//%left            ASSIGN
//%left            LIKE
//%left            AND IOR XOR
//%left            KIN GOT EQ NEQ GTE LTE GT LT
//%left            PLUS MINUS
//%left            TIMES DIVIDES MODULO
//%left            POW ROOT
//%left            LN LOG
//%left            NOT
//%left            FORCE FORCEWITH
//%left            IN SWAP DEPTH POP PEEK JUST_MEMBER
//%left            UMINUS


/*
 *  GRAMMAR
 */


%ebnf
%%
expr            : forcing  -> console.log('hello world!') //-> hi.stack.push.value($forcing)
//              | thunk   -> hi.stack.push.thunk($thunk)
                ;

/*
 *   Forcings
 */
forcing         : literal
//              | operator
                ;
//operator      : binary  -> $binary()
//              | unary   -> $unary()
//              ;
//operator      : unary (expr?)           -> $unary($expr)
//              | (expr?) binary (expr?)  -> $binary($expr1,$expr2)
//              ;
//unary         : FORCE       -> hi.force
//              | FORCEALL    -> hi.forcer
//              | RECV        -> hi.recv
//              | SEND        -> hi.send
//              | DEPTH       -> hi.stack.depth
//              | POP         -> hi.stack.pop
//              | PEEK        -> hi.stack.peek
//              | DROP        -> hi.stack.drop
//              | NOT         -> hi.logic.n
//              ;
//binary        : EQ          -> hi.check.eq
//              | NEQ         -> hi.check.neq
//              | LT          -> hi.check.lt
//              | LTE         -> hi.check.lte
//              | GT          -> hi.check.gt
//              | GTE         -> hi.check.gte
//              | GOT         -> hi.check.got
//              | AND         -> hi.logic.a
//              | IOR         -> hi.logic.o
//              | XOR         -> hi.logic.x
//              | KIN         -> hi.check.kin
//              | LIKE        -> hi.check.like
//              | SWAP        -> hi.stack.swap
//              | PLUS        -> hi.math.plus
//              | MINUS       -> hi.math.minus
//              | TIMES       -> hi.math.times
//              | DIVIDES     -> hi.math.div
//              | POW         -> hi.math.pow
//              | ROOT        -> hi.math.root
//              | LOG         -> hi.math.log
//              | LN          -> hi.math.ln
//              | MODULO      -> hi.math.mod
//              | JUST_MEMBER -> hi.just.member
//              | FORCEWITH   -> function(x,y) { return hi.compose(y,x); }  /* recall x?y == y:x */
//              ;

literal         : boolean
//              | number
//              | string
                ;
boolean         : BOOLEAN
                ;
//number        : '-' number %prec UMINUS -> hi.math.uminus($2)
//              | CONSTANT -> hi(hi.constant[$1])
//              | NUMBER   -> hi($1)
//              ;
//string        : STRING   -> hi($1)
//              ;


/*
 *   Thunks
 */

//thunk           : thunk_literal
//              | symbol
//              | composition
//              | declaration
//                ;
// symbol       : LVALUE   -> hi.sym[$1]
//              | GESTALT  -> hi
//              ;

// remember ASSIGN and DECLARE differ only in that DECLARE is right associative 
// declaration  : LVALUE (ASSIGN|DECLARE) (expr?) -> hi.sym[$1] = (!!$3) ? hi.sym[$1] : {}
//              ;

//composition   : (thunk?) composer thunk -> $composer($1,$3)
//              | composer (thunk?)       -> $composer($2)
//              ;

//composer      : COMPOSE    -> hi.compose
//              | IMPLY      -> hi.imply
//              | GLUE       -> hi.glue
//              | REFLECT    -> hi.reflect
//              | JUST_STACK -> hi.just.syms
//              | JUST_SYMS  -> hi.just.stack
//              | FILTER     -> hi.just
//              ;

//thunk_literal : closure
//              | array
//              | object
//              ;

//object        : LBRCE (kvpair ((COMMA kvpair)*))? RBRCE -> hi({ sym: [ $kvpair, $kvpair ] });
//              ;
//kvpair        : expr COLON expr
//              ;
//array         : LBRKT  expr (COMMA expr)* RBRKT -> hi({ stack: [$expr1,$expr2] });
//              ;
//closure       : empty_cl
//              | inline_cl
//              | multiline_cl
//              ;
//empty_cl      : LPARN RPARN   -> hi.mk.closure.empty()
//              | EMPTY         -> hi.mk.closure.empty()
//              ;
//inline_cl     : LPARN  expr+ RPARN -> hi( { queue: [$expr] } );
//              ;
//multiline_cl  : LPARN expr*  -> hi = hi.hi( { queue: [$expr] } );
//              | expr* RPARN  -> hi = hi.bye({ queue: [$expr] } );
//              ;
/* EOF */
%%
