/* TODO DRY this mess up. Is it permissible refer to previously declared groups from with
 * in the range section? TODO research */
SYM1  [^.,;:/\d\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]-]
SYMN  [^,;:\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]]

%%
\s+          									         /* ignore whitespace */
"--"\b.*   	           					   	      /* ignore comments TODO multiline */ 

("-"?)([1-9]([0-9]*)|("0"+))(("."([0-9]+)([eE]([-+]?)([0-9]+))?)?)\b 	return 'NUMBER'
 
("->"|[⊃⊇→])     									      return 'IMPLY'
(":="|[≔⊢])        									   return 'DECLARE' 
[=]                                             return 'ASSIGN'  
("as"|[↝])                                      return 'AS'                       

/* 
 * Remember, 'as' works by taking an example atom and casting its first argument to the same
 * type as the example. e.g. 
 *
 * '"1" as 0 -- returns 1
 * '"true" as false -- returns true
 * '"true" as true  -- returns true 
*/

[!⚡]         												return 'FORCE'
[?]         												return 'FORCEWITH'

[:∘°]           								         return 'COMPOSE'
[&]         												return 'CONCAT'
[|]           												return 'FILTER'
[%]         												return 'REFLECT' 
[@⊙]         												return 'JUST_STACK'
[*⋆★]                 									return 'JUST_SYMS'
[.]                                    			return 'MEMBER'

("<<"|[«≪])    											return 'IN'   
(">>"|[»≫])                            			return 'OUT'  
[>»≫][~¬]     			         						return 'DROP'  
("><"|[⋈ ])    										   return 'SWAP'

([x×·])       												return 'TIMES'
("div"|[÷])   												return 'DIVIDES'
[+]         												return 'PLUS'
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
("contains" | [∋∍] )  					   			return 'CONTAINS'

/* these are interpreted as bitwise operators (not logical operators) when at least one
   of the arguments is a string. e.g. 'not "true"' will give you back a string containing
   the bitwise negation of the UTF-8 string "true". Surprise! :/

   It's trading off usability against comprhensiveness. Worth it, I think. 
   To get the behaviour you'd expect (e.g. from C) you must first cast: 'not ("true" as true)'
 */ 
   
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
[:]         												return 'COLON'


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
