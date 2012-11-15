/*******************************************************
 *  Hanoi -- core language      			     			   * 
 *******************************************************/ 

%lex
/****CHARACTER CLASSES****/
[0-9]          return 'DECA';
[A-Fa-f0-9]    return 'HEXA';
[A-Za-z]       return 'ALPHA';
[A-Za-z0-9]    return 'ALNUM';

%%

"--".*         /* ignore inline comment */

/* for declarations */
"when"      return 'WHEN';
"whenever"  return 'WHENEVER';
"between"   return 'BETWEEN';
"do"        return 'DO';
"="         return 'ASSIGN';
":="        return 'DECLARE';

/* for thunks and thunking */ 

"(" return 'OPEN';
")" return 'CLOSE'; 
"&" return 'CONCAT';

/* for composition */ 
":" return 'COMPOSE';
"@" return 'ACOMPOS';
"%" return 'HCOMPOS';
"|" return 'FCOMPOS';
"*" return 'TCOMPOS';

/* for forcing and values */
"!" return 'FORCE';
"?" return 'FORCEWARGS';

/* for stack operations */
"_" return 'POP';
"^" return 'SWAP';
"~" return 'DROP';
"#" return 'DEPTH';

/* for I/O operations */
"<" return 'IN';
">" return 'OUT';

/* for strings and characters */
"\" return 'ESCAPEC';
"U+" return 'UPLUS';
"'"return 'SINGLEQ';
'"' return 'DOUBLEQ';

/* for booleans */ 
"true" return 'TRUE';
"false" return 'FALSE';

/* for numbers */
"0x" return 'HEXPREFIX';
"-" return 'NEGATION';

";"            return 'DELIM'; 
\s+            /*skip whitespace*/
<<EOF>>        return 'EOF';

/lex

%right 'DECLARE' 'FORCEWARGS'
%left  'ASSIGN'  'FORCE'

%left  'NEGATION'
%left  'CONCAT'

%left  'POP' 'DROP' 'SWAP' 'DEPTH'
%left  'IN' 'OUT'



%start expressions
%%


expressions    : expression EOF
                           { typeof console !== 'undefined' ? console.log($1) : print($1); 
                             return $1; 
                           } 
               ;

expression		: statement, {DELIM, statement}

STOPPED work here. TODO
<statement>				::= <declaration> | <thunk> | <forcing> |  e 


<declaration>			::= <when> | <let>
<when>					::= <when-lit>, <thunk>, <do-lit>, <thunk> | 
							 <when-lit>, <between-lit>, <thunk>, <do-lit>, <thunk> | 
							<whenever-lit>,  <thunk>, <do-lit>, <thunk>
<let>					::= <lvalue>, <assignment-oper>, <rvalue>
<lvalue>				::= <lvalue-first-char>, {<lvalue-later-char>} | 
							<lvalue-oper-char>, {lvalue-oper-char}
<lvalue-first-char>		::= <alpha> | <deca>
<lvalue-later-char>		::= <alpha>
<lvalue-oper-char>		::= <oper>

<rvalue>				::= <thunk> | <forcing>

/* grammar for thunking, aka creating deferred computations (promises) */
<thunk>					::= <grouped-thunk> | <concatted-thunk> | <composed-thunk> | <lvalue>
<grouped-thunk>			::= <open-group-oper>, <expression>, <close-group-oper>
<concatted-thunk>		::= <statement>, {<concat-oper>, <statement>} 
<composed-thunk>		::= <vanilla-comp> | <array-comp> | <hash-comp> | <filter-comp> | <trans-comp>
<vanilla-comp>			::= <thunk>, <vanilla-comp-oper>, <thunk>
<array-comp>			::= <thunk>, <array-comp-oper>  , <thunk>
<hash-comp>				::= <thunk>, <hash-comp-oper>   , <thunk>
<filter-comp>			::= <thunk>, <filter-comp-oper> , <thunk>
<trans-comp> 			::= <thunk>, <trans-comp-oper>, <thunk>

/* grammar for values, aka forced entities, aka push values, aka computation results, aka literals */
<forcing>				::= <bare-force> | <force-with-args> | <implied-force>
<bare-force>			::= <thunk>, <force-bare-oper>
<force-with-args>		::= <thunk>, <force-args-oper>, <thunk>;  /* second thunk == args */
<implied-force>			::= <operation> | <atom>

<atom>					::= <number> | <character> | <boolean> | <string>

<operation>				::= <io-op> | <stack-op>
<stack-op>				::= <pop> | <drop> | <swap> | <depth>; /* recall no push */
<io-op>					::= <in> | <out>


/**** SYNTAX ****/ 

/* for strings */ 
<string>				::= <double-quote-lit>,[<any-unicode-char-except-2quote>],<double-quote-lit>  |
							<single-quote-lit>,<any-unicode-char-except-1quote>,
											   <any-unicode-char-except-1quote>, 
 											  {<any-unicode-char-except-1quote>},<single-quote-lit>


/* for single characters */ 

<character>				::= <single-quote-lit>,<any-unicode-char-except-1quote>,<single-quote-lit>	| 
							<escape-char>,<escaped-char-code>    				|	
							<unicode-escape-prefix>,<hexa>,<hexa>,<hexa>,<hexa>	| 

							/* notice dodge of ambiguity: the literal /'x'/ might be a char or a string. So mandate strings with single quotes must be at least 2 chars long */


/* for booleans */
<boolean>				::= <true-lit> | <false-lit>

/* for numbers */ 
<number>				::= <decimal> | <hexadecimal>
<decimal>				::= <integer>; /* TODO add floats back */ 
<integer>				::= [<neg-lit>],<positive>
<positive>				::= <deca>,{<deca>}
<hexadecimal>			::= <hex-prefix>,<hexa>,{<hexa>}
%%
