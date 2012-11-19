/*******************************************************
 *  Hi-Script -- core language      			     			   * 
 *******************************************************/ 

%lex
DECA  [0-9]
DCNZ  [1-9]
/* TODO DRY this mess up. Is it permissible refer to previously declared groups from with
 * in the range section? TODO research */
SYM1  [^.,;:/\d\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]-]
SYMN  [^,;:\\^_~!@#$%^&*()<>|?!"`'=\s{}\[\]]

%%
\s+          
"---"\b.*    /*  TODO add multiline comments with /^---$/ for both open and close */
[\n;]+      return 'DELIMITER'
("-"?)({DCNZ}({DECA}*)|"0"+)\b             return 'INT'
("-"?)({DCNZ}({DECA}*)|"0"+)"."({DECA}+)\b return 'FLOAT' /*TODO scientific notation*/
"when"      return 'WHEN'
"whenever"  return 'WHENEVER'
"between"   return 'BETWEEN'
"->"        return 'DO'
"="         return 'ASSIGN'  
"<-"        return 'DECLARE' 
":"         return 'COMPOSE'
"&"         return 'CONCAT'
"@"         return 'MKARRAY'
"|%"         return 'MKOBJ'
"|"         return 'FILTER'
"%"         return 'REFLECT'
"!"         return 'FORCE'
"?"         return 'FORCEWITH'
"$"         return 'GESTALT' 
"#"         return 'DEPTH'   
"+"         return 'PLUS'
"-"         return 'MINUS'
"*"         return 'TIMES'
"/"         return 'DIVDBY'
"_"         return 'POP'  
"__"        return 'PEEK'
"^"         return 'SWAP'
"~"         return 'DROP' 
"<"         return 'IN'   
">"         return 'OUT'  
"'"         return 'Q'
'"'         return 'QQ'
"true"      return 'T'
"false"     return 'F'
"("         return 'LPARN'
")"         return 'RPARN' 
"["         return 'LBRKT'
"]"         return 'RBRKT'
"{"         return 'LBRCE'
"}"         return 'RBRCE'
"{}"        return 'EMPTY'
":"         return 'COLON'
","         return 'COMMA'
"."         return 'DOT'
{SYM1}({SYMN}*)\b return 'SYMBOL'                
<<EOF>>     return 'EOF'
            return 'INVALID'

/lex
%right 'WHEN' 'WHENEVER' 'BETWEEN' 'DECLARE' 'FORCEWITH'
%left  'ASSIGN' 'FORCE' 'PLUS' 'MINUS' 'TIMES' 'DVDBY' 'POP' 'PEEK' 'DROP' 'SWAP' 'IN' 'OUT' 'COMPOSE' 'CONCAT' 'MKARRAY' 'MKOBJ' 'FILTER' 'REFLECT' 'DOT' 'COLON'
%ebnf 
%start code
%%
input            : input line 
line             (expr?) delimiter                
expr             : thunk | forcing 

/*
 * THUNKS
 */

thunk				  : SYMBOL | declaration | composition | object | array | closure

/* attach a thunk to an event or a symbol */
declaration      : SYMBOL (ASSIGN|DECLARE) (expr?) (WHEN | WHENEVER | BETWEEN) (expr?) DO (thunk?)

/* note that these aren't technically 'operators', which in hi-script implies a force */
composition      : (thunk?) comp thunk | comp (thunk?) | idx_into_array 
comp             : COMPOSE | CONCAT | MKARRAY | MKOBJ | FILTER | REFLECT | DOT
idx_into_array   : (thunk?) LBRKT (expr?) RBRKT 

/* these are all different ways of expressing a thunk literal */
object           : LBRCE (expr  COLON expr ((COMMA expr COLON expr)*))? RBRCE | EMPTY
array            : LBRKT  expr (COMMA expr)* RBRKT
closure          : LPARN  expr* RPARN

/*
 * FORCINGS
 */
forcing			  : atom | operator

operator         : unary | (expr?) binary (expr?)
unary            : DEPTH | GESTALT | POP  | PEEK | DROP | IN | OUT | FORCE
binary           : SWAP | PLUS | MINUS | TIMES | DVDBY | FORCEWITH

atom             : boolean | number | string
string			  : Q  CHAR* Q | QQ CHAR* QQ
number			  : INT | FLOAT
boolean			  : T | F
%%
