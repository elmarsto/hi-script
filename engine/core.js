	
//TODO break this up into multiple files, it's way too long (both vertically and horizontally!)
//TODO finish stubbing out the parser

var exports = (function () {

  var  funcy = require('funcy.js'),
       core  = {
	constant: { /* constant table -- TODO */ },
	type: {
		monad: funcy ( function () {/*TODO*/},  {
		  parselevel: -1,
		  sym: { /* symbol table -- populated at runtime */ },
		  queue: [ /* instructions coming up -- populated at runtime */],
		  history: [ /* instructions already parsed -- populated at runtime  */],
		  iz: { monad: true, begun: false, finished: false },
		  noop: function() { /* nothing here */ return this; },
		  hi: function(x) { 
		      /* initiate child parsing context */  
		      this.parselevel++; 
		      var new_context = this.apply(x); 
		      new_context.parent = this;

		      //magic to make the child's sym table prototypically inherit from the parent's sym table (efficient lookups)
		      var fake_constructor = function(x) { var k; for (k in x) { if (x.hasOwnProperty(k)) { this.sym[k] = x[k]; } } return this; };
		      fake_constructor.prototype = this.sym;
		      new_context.sym = new fake_constructor((!!x.sym) ? x.sym : {});
		      return new_context; 
		  }, 
		  bye: function() {/* pop out to parent parsing context */ this.parselevel--; return this.parent;},
		  force: function () { /* TODO */  return this;},
		  forcer: function () { /* TODO; nm. 'force recursively' */  return this; },
		  send: function () { this.parent.stack.shift(this.stack.pop()); return this; },
		  recv: function () { this.stack.unshift(this.parent.stack.pop()); return this; },
		  parent:  null, /* for subcontexts, set by constructor core.type.hi() to parent monad	*/
		  like:   function () { /* typecasting, basically */ },
		  stack: funcy( function () {/*TODO*/} , {
			push: function () {/*TODO*/},
			pop:  function () {/*TODO*/},
			drop: function () {/*TODO*/},
			peek: function () {/*TODO*/},
			swap: function () {/*TODO*/},
			content: [ /* populated at runtime, same as above */],
		  }),
		  just: funcy( function () {/*TODO*/},
		      {
			 member:  function () {/*TODO*/},
			 stack:   function () {/*TODO*/},
			 syms: function () {/*TODO*/}
		       }
		  ), //just
		  compose:  function () {/*TODO*/},
		  reflect:  function () {/*TODO*/},
		  imply:    function () {/*TODO*/},
		  glue:	    function () {/*TODO*/},
		  math: {
			   log:	function () {/*TODO*/},
			   ln:	function () {/*TODO*/},
			   pow:	function () {/*TODO*/},
			   root: function () {/*TODO*/},
			   uminus: function () {/*TODO*/},
			   minus: function () {/*TODO*/},
			   times: function () {/*TODO*/},
			   div:	function () {/*TODO*/},
			   mod:	function () {/*TODO*/},
		  }, //math
		  check: {
			eq:		function () {/*TODO*/},
			neq:		function () {/*TODO*/},
			lte:		function () {/*TODO*/},
			gte:		function () {/*TODO*/},
			gt :		function () {/*TODO*/},
			lt :		function () {/*TODO*/},
			contains:	function () {/*TODO*/},
			kin:		function () {/*TODO*/},
		  }, //logic
		  logic: {
			n:		function () {/*TODO*/},
			a:		function () {/*TODO*/},
			o:		function () {/*TODO*/},
			x:		function () {/*TODO*/},
		  }, //logic
		}), //monad
		number: funcy( function () {/*TODO*/} , {
			iz: funcy( function () {/*TODO*/}, { number: true, atom: true } ),
			plus : function () {/*TODO*/},
			minus: function () {/*TODO*/},
			times: function () {/*TODO*/},
			div  : function () {/*TODO*/},
			mod  : function () {/*TODO*/},
			log  : function () {/*TODO*/},
			ln   : function () {/*TODO*/},
			pow  : function () {/*TODO*/},
			root : function () {/*TODO*/}
		}),
		string: funcy ( function () {/*TODO*/}, {
			haz: funcy( function () {/*TODO*/}, { length: function () {/*TODO*/} } ),
			iz: funcy( function () {/*TODO*/}, { string: true, atom: true } ),
		}) //string
	}//type
       };//core

  core.type.monad.core = core;
  return core.type.monad;

}());


