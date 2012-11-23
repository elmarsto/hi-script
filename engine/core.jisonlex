/* TODO DRY this mess up. Is it permissible refer to previously declared groups from with
 * in the range section? TODO research */
SYM1  [^.,;:/\d\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]-]
SYMN  [^,;:\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]]
%x cblk /* comment block */
%x q /* single-quoted string literal */
%x qq /* double-quoted string literal */
%s array
%s object 
%%
\s+          									         /* ignore whitespace */


"--".*   	           					   	      /* ignore inline comments */
^"---".*                                        this.begin('cblk')
<cblk>^"---".*                                  this.popState()
<cblk>.*                                        /* ignore comment body */


/*this is a mess. Simplify? How? Irreducible complexity? Explicitness vs noise? */
([1-9]([0-9]*)|"0")(("."([0-9]+)(([eE]([-+]?)([0-9]+))?))?)\b 	return 'NUMBER'

 
("->"|[⊃⊇→])     									      return 'IMPLY'
(":="|[≔⊢])        									   return 'DECLARE' 
[=]                                             return 'ASSIGN'  
("like"|[↝])                                    return 'LIKE'                       

/* 
 * Remember, 'like' works by taking an example atom and casting its first argument to the same
 * type as the example. e.g.  "1" like 0 -- returns 1
*/

[!⚡]         												return 'FORCE'
[?]         												return 'FORCEWITH'

[:∘°]           								         return 'COMPOSE'
[&]         												return 'GLUE'
[|]           												return 'FILTER'
[%]         												return 'REFLECT' 
[@⊙]         												return 'JUST_STACK'
[*⋆★]                 									return 'JUST_SYMS'
[.]                                    			return 'JUST_MEMBER'

("<<"|[«≪])    											return 'IN'   
(">>"|[»≫])                            			return 'OUT'  
[>»≫][~¬]     			         						return 'DROP'  
("><"|[⋈ ])    										   return 'SWAP'

("mult"|[×·])       										return 'TIMES'
("div"|[÷])   												return 'DIVIDES'
[+]         												return 'PLUS'     /* also string concat */
[-]         												return 'MINUS'    
("pow"|[^])   												return 'POW'
("root"|[√])                                    return 'ROOT'    
"mod"                                           return 'MODULO'
"ln"                                            return 'LN'
"log"                                           return 'LOG'

[<<﹤＜]                               			return 'LT'
("<="|"<=="|[≤])                       			return 'LTE'
[>>﹥＞]                               			return 'GT'
(">="|">=="|[≥])                       			return 'GTE'
("=="|"==="|[≃])                       			return 'EQ'
("!="|"!=="|[≄])                       			return 'NEQ'
("contains"|[∋∍])  					   			   return 'CONTAINS' /* works on substrings too */

   
("not"|[¬~])												return 'NOT'
("&&"|"and"|[∪∨])		    								return 'AND'
("||"|[i]?"or"|[∩∧])                   			return 'IOR'
("xor"|[⨁⊻])		             						return 'XOR'


"("         												return 'LPARN'
")"         												return 'RPARN' 
"["         												return 'LBRKT'
"]"         												return 'RBRKT'
"{"         												return 'LBRCE'
"}"         												return 'RBRCE'


[$ß]          												return 'GESTALT' 
("..."  |[…])	      									return 'ELLIPSIS'
("{}"|"()"|[∅])   										return 'EMPTY'
("false" | "true" |[⊥⊤])    							return 'BOOLEAN'
[ℯπ∞ιφ]                                         return 'CONSTANT'

{SYM1}({SYMN}*)\b 										return 'LVALUE'

<array,object>[,]    									return 'COMMA'
<array,object>[:]                               return 'COLON' 

[\n;]                                           return 'DELIMITER'

(["])                                           this.begin('qq')
(['])                                           this.begin('q')
<qq>([^\\]["])                                  this.popState()
<q>([^\\]['])                                   this.popState()
<qq,q>(.*)                                      return 'STRING'

<<EOF>>     												return 'EOF'

            												return 'INVALID
