/* TODO DRY this mess up. Is it permissible refer to previously declared groups from with
 * in the range section? TODO research */
SYM1  [^.,;:/\d\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]-]
SYMN  [^,;:\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]]
HEXA  [A-Fa-f0-9]
%%
\s+          									         /* ignore whitespace */
"--"\b.*   	           					   	      /* ignore comments TODO multiline */ 


/*this is a mess. Simplify? How? Irreducible complexity? */
("-"?)([1-9]([0-9]*)|("0"+))(("."([0-9]+)([eE]([-+]?)([0-9]+))?)?)\b 	return 'NUMBER'

"0x"{HEXA}({HEXA}*)                             return 'NUMBER'
 
("->"|[⊃⊇→])     									      return 'IMPLY'
(":="|[≔⊢])        									   return 'DECLARE' 
[=]                                             return 'ASSIGN'  
("like"|[↝])                                    return 'LIKE'                       

/* 
 * Remember, 'like' works by taking an example atom and casting its first argument to the same
 * type as the example. e.g. 
 *
 * '"1" like 0 -- returns 1
 * '"true" like false -- returns true
 * '"true" like true  -- returns true 
*/

[!⚡]         												return 'FORCE'
[?]         												return 'FORCEWITH'

[:∘°]           								         return 'COMPOSE'
[&]         												return 'GLUE'
[|]           												return 'FILTER'
[%]         												return 'REFLECT' 
[@⊙]         												return 'JUST_STACK'
[*⋆★]                 									return 'JUST_SYMS'
[.]                                    			return 'MEMBER'

("<<"|[«≪])    											return 'IN'   
(">>"|[»≫])                            			return 'OUT'  
[>»≫][~¬]     			         						return 'DROP'  
("><"|[⋈ ])    										   return 'SWAP'

("mult"|[×·])       										return 'TIMES'
("div"|[÷])   												return 'DIVIDES'
[+]         												return 'PLUS'     /* also string concat */
[-]         												return 'MINUS'    
("exp"|[^])   												return 'EXPONENT'
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


[']          												return 'Q'
["]                										return 'QQ'
"("         												return 'LPARN'
")"         												return 'RPARN' 
"["         												return 'LBRKT'
"]"         												return 'RBRKT'
"{"         												return 'LBRCE'
"}"         												return 'RBRCE'
":"         												return 'COLON'


[$ß]          												return 'GESTALT' 
("..."  |[…])	      									return 'ELLIPSIS'
("{}"|"()"|[∅])   										return 'EMPTY'
("true" |[⊤])    											return 'T'
("false"|[⊥])   											return 'F'
[ℯ]                                             return 'E'
[π]                                             return 'PI'
[∞]                                             return 'INFINITY'
[ⅈι]                                            return 'IMAGINARY'
[φ]                                             return 'GOLDEN'

{SYM1}({SYMN}*)\b 										return 'SYMBOL'

[,]         												return 'COMMA'
[\n;]                                           return 'DELIMITER'

<<EOF>>     												return 'EOF'

            												return 'INVALID
