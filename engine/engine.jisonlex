
SYMN  [^,;:\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]]
SYM1  [^.,;:/\d\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]-]

%x cblk
%x q
%x qq
%s array
%s object
%%
----
\s+                                             {/* ignore whitespace */}
"--".*                                          {/* ignore inline comments */}
// ignore block  comments
^"---"$                                        this.begin('cblk') // begin  comment blk
<cblk>^"---"$                                  this.popState()    // end    comment blk
<cblk>.*                                       {/* ignore block comments */}
// Identify delimiter
[;\n]                                              return 'DELIMITER';

//// Identify keywords and primitives
//("->"|[⊃⊇→])                                    return 'IMPLY';
//(":="|[≔⊢])                                     return 'DECLARE';
//[=]                                             return 'ASSIGN';
//// Remember, 'like' works by taking an example atom and casting its
//// first argument to the same type as the example. e.g.  "1" like 0 -- returns 1;
//("like"|[↝])                                    return 'LIKE';
//[!]                                             return 'FORCE';
//("!!"|[⚡])                                      return 'FORCEALL';
//[?]                                             return 'FORCEWITH';
//
//[:∘°]                                           return 'COMPOSE';
//[&]                                             return 'GLUE';
//[|]                                             return 'FILTER';
//[%]                                             return 'REFLECT';
//[@⊙]                                            return 'JUST_STACK';
//[*⋆★]                                           return 'JUST_SYMS';
//[.]                                             return 'JUST_MEMBER';
//
//("<<"|[«≪])                                     return 'RECV';
//(">>"|[»≫])                                     return 'SEND';
//[>»≫][~¬]                                       return 'DROP';
//("><"|[⋈ ])                                     return 'SWAP';
//
//("times"|[×·])                                  return 'TIMES';
//("div"|[÷])                                     return 'DIVIDES';
//[+]                                             return 'PLUS'     // also string concat;
//[-]                                             return 'MINUS';
//("pow"|[^])                                     return 'POW';
//("root"|[√])                                    return 'ROOT';
//"mod"                                           return 'MODULO';
//"ln"                                            return 'LN';
//"log"                                           return 'LOG';
//
//("kin"|[≋])                                     return 'KIN';
//[<<]                                            return 'LT';
//("<="|"<=="|[≤])                                return 'LTE';
//[>>]                                            return 'GT';
//(">="|">=="|[≥])                                return 'GTE';
//("=="|"==="|[≃])                                return 'EQ';
//("!="|"!=="|[≄])                                return 'NEQ';
//("got"|[∋∍])                                    return 'GOT';

//("not"|[¬~])                                    return 'NOT';
//("&&"|"and"|[∪∨])                               return 'AND';
//("||"|[i]?"or"|[∩∧])                            return 'IOR';
//("xor"|[⨁⊻])                                    return 'XOR';

// Identify special names
//[$ß]                                          return 'GESTALT';
//("..."|[…])                                   return 'ELLIPSIS';
//("[]"|"{}"|"()"|[∅])                               return 'EMPTY';
//[ℯπ∞ιφ]                                     return 'CONSTANT';
//[ℯπφ]                                         return 'CONSTANT';

// Identify structuring tokens

//"("                                            return 'LPARN';
//")"                                            return 'RPARN';
//"["                                            return 'LBRKT';
//"]"                                            return 'RBRKT';
//"{"                                            return 'LBRCE';
//"}"                                            return 'RBRCE';


// Whew! on to lexing of lvalues.

//{SYM1}({SYMN}*)\b                             return 'LVALUE';


// And now for the lexing of datatypes.


// Booleans
//("false"|"true"|[⊥⊤])                      return 'BOOLEAN';
("false"|"true")                      return 'BOOLEAN';


// Identify Floats and Integers
// FIXME this is a mess. Simplify? How? Irreducible
// complexity? Explicitness vs noise?
//([1-9]([0-9]*)|"0")(("."([0-9]+)(([eE]([-+]?)([0-9]+))?))?)\b   return 'NUMBER';

// Identify Strings
//(["])                                         this.begin('qq')
//(['])                                         this.begin('q')
//<qq>([^\\]["])                                this.popState()
//<q>([^\\]['])                                 this.popState()
//<qq,q>(.*)                                    return 'STRING';

// Arrays and objects.
//<array,object>[,]                             return 'COMMA';
//<array,object>[;]                             return 'DELIMITER' //allow multiline;
//<array,object>[:]                             return 'COLON';

// Final step: gracefully handle EOF, freak out if nothing thus far has matched
<<EOF>>                                       return 'EOF';

                                               return 'INVALID';
