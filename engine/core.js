
//TODO break this up into multiple files, it's way too long
//TODO finish stubbing out the parser

exports = (function() {

var funcy = require('funcy.js');
/* declare the namespace object. */ 
var core = {
		make:  funcy( 
		  function () {}, 
		  { 
			  bool:   function () { return this.type.bool.make.apply(this,arguments);	},
			  number: function () { return this.type.number.make.apply(this,arguments); },
			  string: function () { return this.type.string.make.apply(this,arguments); },
			  atom:   function () { return this.type.atom.make.apply(this,arguments);	},
			  monad:  function () { return this.type.monad.make.apply(this,arguments);	} 
		  }
		),
		constant: function (x){},
		type: {
			entity: { iz: function() { return true; }, },
			atom:  { 
				  iz: { atom: true }, 
				 haz: { value: function() {}, } 
			},
			monad: { 
			  iz:	{ monad: true },
			  io:	  {},
			  stack:  {},
			  trans:  funcy( 
			   function () {}, 
			   { 
				 like: function() {},
				 swap: function() {},
				 just:	funcy( 
					function () {}, 
					{
					 member:  function() {},
					 stack:   function() {},
					 symbols: function() {}
				   }
				 ),
				 compose: funcy( 
				   function () {}, 
				   { 
					 reflect: function() {},
					 imply:   function() {},
					 glue:	  function() {},
				   }
				 ),
				 math: {
					 log:	function() {},
					 ln:	function() {},
					 pow:	function() {},
					 root:	function() {},
					 uminus:function() {},
					 minus: function() {},
					 times: function() {},
					 div:	function() {},
					 mod:	function() {},
					 log:	function() {},
					 ln:	function() {},
				  } //math
				}
			  ), //trans
			  logic: {
				  n:		function() {},
				  eq:		function() {},
				  neq:		function() {},
				  lte:		function() {},
				  gte:		function() {},
				  gt :		function() {},
				  lt :		function() {},
				  contains: function() {},
				  kin:		function() {}, 
				} //logic
				sym:  function() {},
				make: funcy( 
					function() { },
					{ 
					bool:	 
					  function() { return core.type.bool.make.apply(this,arguments); },
					string:
					  function() { return core.type.string.make.apply(this,arguments); },
					number: 
					  function() { return core.type.number.make.apply(this,arguments); },
					object: 
					  function() { return core.type.object.make.apply(this,arguments); },
					array: 
					  function() { return core.type.array.make.apply(this,arguments); },
					}
				),
			   bye: function() {}
			 }, //monad
			stack: {
				haz { depth: function() {} },
				iz	{ empty: function() {}, stack: true },
				push: function() {},
				pop:  function() {},
				drop: function() {},
				peek: function() {},
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
  


//utility function for twiddling inheritance
var _adopt = function() {
  var args = _args(arguments),
	  mom  = args.shift(), //mom is first argument 
	  kids = args;		   //all kids come next
	  
	  kids.forEach(function(k) { k.__proto__ = mom; });
};

//atoms, symbols, stacks and monads are entities
_adopt(core.type.entity, core.type.atom, core.type.stack, core.type.monad);

//Numbers, strings, and booleans are atoms
_adopt(core.type.atom, core.type.number, core.type.string, core.type.bool);


return core;
})();
