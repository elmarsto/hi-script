
//TODO break this up into multiple files, it's way too long
//TODO write mixtress.js
//TODO finish stubbing out the parser

require ('mixtress')

/* step one: declare the namespace object. */ 
core = { 
				make: { /* low-level routines to create internal data structures. */
						'.': function() {}, 
						bool: function (x) {},
						number: function (x) {},
						string: function (x) {},
						atom: function(x) {},
						monad: function(x) {}
					   },
				constant: function (x){},
				type: {
						entity: {
								 iz: function() { return true; },
								},
						atom: { 
								 iz: { atom: true }, 
								 haz: { value: function() {}, },
							  },
						symbol: {
								 iz: {
										symbol: true,
										declared: function() {},
										empty: function() {},
									}
								 haz: { 
										referent: function() {},
										literal: function() {},
								 },
						},
						monad: { //TODO refactor into separate file
							iz: { monad: true },
							io: {},
							stack: {},
							trans:	{
							   '.' : function() {},
							   like: function() {},
							   swap: function() {},
							   just:{
									   '.': function() {}, 
									   member: function() {},
									   stack: function() {},
									   symbols: function() {}
									 },
							   compose: {
									   '.': function() {}, 
									   reflect: function() {},
									   imply: function() {},
									   glue: function() {},
									 },
							   math: {
									   log: function() {},
									   ln:	function() {},
									   pow: function() {},
									   root: function() {},
									   uminus: function() {},
									   minus: function() {},
									   times: function() {},
									   div: function() {},
									   mod: function() {},
									   log: function() {},
									   ln: function() {},
								  } //math
							} //trans
							logic: {
								  n:  function() {},
								  eq: function() {},
								  neq: function() {},
								  lte: function() {},
								  gte: function() {},
								  gt : function() {},
								  lt : function() {},
								  contains: function() {},
								  kin: function() {}, 
							  } //logic
							  sym:	function() {},
							  make: { 
									  '.':	function() {},
									  bool: function() {},
									  string: function() {},
									  number: function() {},
									  object: function() {},
									  array: function() {},
								  },
							 bye: function() {}
						 }, //monad
						stack: {
								   haz { depth: function() {} },
								   iz { empty: function() {},
										stack: true },
								   push: function() {},
								   pop: function() {},
								   drop: function() {},
								   peek: function() {},
							   },
						transform: {
								   iz { forced: function() {} },
								   wants: function() {},
								   must: function() {},

							   },
						number: {
								iz: { 
										exactly: function() {},
										equalTo: function() {},
										number: true,
								},
								plus: function() {},
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
								haz: { 
										length: function() {},
									 },
								iz: { 
										string: true,
										interpolated: function() {},
									 },
							 } //string
						}//type
};	//core
  


/* Step II: Use the mixtress lib to use mixins to provide cheap inheritancelike behaviours and properties */
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

