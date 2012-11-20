DECA  [0-9]
DCNZ  [1-9]
/* TODO DRY this mess up. Is it permissible refer to previously declared groups from with
 * in the range section? TODO research */
SYM1  [^.,;:/\d\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]-]
SYMN  [^,;:\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]]

%%
\s+          									         /* ignore whitespace */
"--"\b.*   	           					   	      /* ignore comments TODO multiline */ 


("-"?)({DCNZ}({DECA}*)|"0"+)\b  				      return 'INT'
("-"?)({DCNZ}({DECA}*)|"0"+)"."({DECA}+)\b 		return 'FLOAT'

("->"|[⊃⊇→])     									      return 'IMPLY'
(":="|[⊢])         									   return 'DECLARE' 
[=]                                             return 'ASSIGN'  

[!⚡]         												return 'FORCE'
[?]         												return 'FORCEWITH'

[:]           									         return 'COMPOSE'
[&]         												return 'CONCAT'
[@⊙]         												return 'MKARRAY'
[*⋆★]                 									return 'MKOBJ'
[|]           												return 'FILTER'
[%]         												return 'REFLECT'

[_]          												return 'POP'  
("__"|[‿])     					   					return 'PEEK'
[#]           												return 'DEPTH'   

[$ß]          												return 'GESTALT' 
[.]                                    			return 'MEMBER'
[∋∍]          								   			return 'ISMEMBER'
("..."  |[…])	      									return 'ELLIPSIS'

("<<"|[«≪])    											return 'IN'   
(">>"|[»≫])                            			return 'OUT'  
(">>"|[»≫])([~¬])    									return 'DROP'  
("^"|[⥮])    												return 'SWAP'

[×]         												return 'TIMES'
[÷]         												return 'DIVDBY'
[+]         												return 'PLUS'
[-]         												return 'MINUS'

[<<﹤＜]                               			return 'LT'
("<="|"<=="|[≤])                       			return 'LTE'
[>>﹥＞]                               			return 'GT'
(">="|">=="|[≥])                       			return 'GTE'
("=="|"==="|[≡])                       			return 'EQUALS'
("!="|"!=="|[≢])                       			return 'NEQUALS'

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

("{}"|"()"|[∅])   										return 'EMPTY'
("true" |[⊤])    											return 'T'
("false"|[⊥])   											return 'F'
[ℯ]                                             return 'E'
[π]                                             return 'PI'

{SYM1}({SYMN}*)\b 										return 'SYMBOL'

[,]         												return 'COMMA'
[\n;]                                           return 'DELIMITER'
<<EOF>>     												return 'EOF'
            												return 'INVALID
