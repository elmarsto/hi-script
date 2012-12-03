
//TODO break this up into multiple files, it's way too long
//TODO write mixtress.js
//TODO finish stubbing out the parser

require ('mixtress')

/* step one: declare the namespace object. */ 
core = { 
				make: { /* low-level routines to create internal data structures. */
						'.':    function () {}, 
						bool:   function ()	{ return this.type.bool.make.apply(this,arguments);   },
						number: function () { return this.type.number.make.apply(this,arguments); },
						string: function () { return this.type.string.make.apply(this,arguments); },
						atom:   function()	{ return this.type.atom.make.apply(this,arguments);   },
						monad:  function()	{ return this.type.monad.make.apply(this,arguments);  }
					   },
				constant: function (x){},
				type: {
						entity: { iz: function() { return true; }, },
						symbol: {
								iz:  { symbol: true }
								haz:  { referent: function() {}, 
										literal: function() {} 
									  },
						},
						atom:   { iz: { atom: true }, 
								 haz: { value: function() {}, }, },
						monad: { 
							iz: 	{ monad: true },
							io: 	{},
							stack:  {},
							trans:	{
							   '.' : function() {},
							   like: function() {},
							   swap: function() {},
							   just:{
									   '.': 	function() {}, 
									   member: 	function() {},
									   stack: 	function() {},
									   symbols: function() {}
									 },
							   compose: {
									   '.': 	function() {}, 
									   reflect: function() {},
									   imply: 	function() {},
									   glue: 	function() {},
									 },
							   math: {
									   log: 	function() {},
									   ln:		function() {},
									   pow: 	function() {},
									   root: 	function() {},
									   uminus: 	function() {},
									   minus: 	function() {},
									   times: 	function() {},
									   div: 	function() {},
									   mod: 	function() {},
									   log: 	function() {},
									   ln: 		function() {},
								  } //math
							} //trans
							logic: {
								  n: 			function() {},
								  eq: 			function() {},
								  neq: 			function() {},
								  lte:			function() {},
								  gte: 			function() {},
								  gt : 			function() {},
								  lt : 			function() {},
								  contains: 	function() {},
								  kin: 			function() {}, 
							  } //logic
							  sym:	function() {},
							  make: { 
									  '.':	function() {
									 	var out = {}; 
										out.prototype = core.type.monad;
									  	out.io 		  = core.type.stack.make(/*TODO*/);
										out.stack 	  = core.type.stack.make();
									  },
									  bool: function () 
										  { return core.type.bool.make.apply(this,arguments); },
									  string: function() {},
										  { return core.type.string.make.apply(this,arguments); },
									  number: function() {},
										  { return core.type.number.make.apply(this,arguments); },
									  object: function() {},
										  { return core.type.object.make.apply(this,arguments); },
									  array: function() {},
										  { return core.type.array.make.apply(this,arguments); },
								  },
							 bye: function() {}
						 }, //monad
						stack: {
								haz { depth: function() {} },
								iz  { empty: function() {}, stack: true },
								push: function() {},
								pop:  function() {},
								drop: function() {},
								peek: function() {},
							 },
						transform: {
						   		iz { forced: function() {} },
							 },
						number: {
								iz: { number: true,},
								plus:  function() {},
								minus: function() {},
								times: function() {},
								div  : function() {},
								mod  : function() {},
								log  : function() {},
								ln	 : function() {},
								pow  : function() {},
								root : function() {}
							},
						string: {
								haz: { length: function() {}, },
								iz:  { string: true, interpolated: function() {} },
							 } //string
						}//type
};	//core
  


/* Use mixins to add uniform substructures */
mixtress.into( { iz: { forced: true } },
				core.type.monad.trans.math.plus,
				core.type.monad.trans.math.minus,
				core.type.monad.trans.math.uminus,
				core.type.monad.trans.math.times,
				core.type.monad.trans.math.div,
				core.type.monad.trans.math.mod,
				core.type.monad.trans.math.log,
				core.type.monad.trans.math.ln,
				core.type.monad.trans.math.root,
				core.type.monad.trans.math.pow,
				core.type.monad.trans.swap,
				core.type.monad.trans.like,
				core.type.monad.trans.just.member,
				core.type.monad.logic.eq,
				core.type.monad.logic.neq,
				core.type.monad.logic.gt,
				core.type.monad.logic.lt,
				core.type.monad.logic.lte,
				core.type.monad.logic.gte,
				core.type.monad.logic.contains
				core.type.monad.logic.kin,
				core.type.stack.drop,
				core.type.stack.push,
				core.type.stack.pop,
				core.type.stack.peek,
				core.type.stack.depth,
				core.type.atom );

mixtress.into( { iz: { forced: false } },
				core.type.monad,
				core.type.monad.trans.compose,
				core.type.monad.trans.compose.reflect,
				core.type.monad.trans.compose.imply,
				core.type.monad.trans.compose.glue,
				core.type.monad.trans.just.symbols,
				core.type.moand.trans.just.stack,
				core.type.monad.trans.just );

/* I could use prototypical inheritance for the next three, but ATM we're doing it with
 * mixins for consistency with the above pattern (borrowed from 
 * https://speakerdeck.com/anguscroll/how-we-learned-to-stop-worrying-and-love-javascript) */


//atoms, symbols, stacks and monads are entities
mixtress.into.beneath( core.type.entity,
					   core.type.constant, core.type.atom, core.type.symbol,
					   core.type.stack, core.type.monad );

//Numbers, strings, and booleans are atoms
mixtress.into.beneath( core.type.atom, 
					   core.type.number, core.type.string, core.type.bool );

//Transforms and symbols are monads
mixtress.into.beneath( core.type.monad, 
					   core.type.symbol, core.type.transform );

