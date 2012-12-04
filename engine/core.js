
//TODO break this up into multiple files, it's way too long
//TODO finish stubbing out the parser

var core = {};

(function() {

/* utility function takes a function and a JSON object and returns something that is both */
var _funcy = function(f,j) {
    var ff = function() { return f.apply(this,arguments); }; // 'forwarding function'
    for (p in j) {     
      if (j.hasOwnProperty(p) && 
          j.isEnumerable(p))
        ff[p] = j[p];
    }
    return ff;
}; 

/* step one: declare the namespace object. */ 
core = { 
        make:  _funcy( 
          function () {}, 
          { 
              bool:   function () { return this.type.bool.make.apply(this,arguments);   },
              number: function () { return this.type.number.make.apply(this,arguments); },
              string: function () { return this.type.string.make.apply(this,arguments); },
              atom:   function () { return this.type.atom.make.apply(this,arguments);   },
              monad:  function () { return this.type.monad.make.apply(this,arguments);  } 
          }
        ),
        constant: function (x){},
        type: {
            entity: { iz: function() { return true; }, },
            symbol: {
                iz:  { symbol: true }
                haz:  { 
                        signifier:  function() {}, 
                        signified:  function() {} 
                      },
            },
            atom:  { 
                  iz: { atom: true }, 
                 haz: { value: function() {}, } 
            },
            monad: { 
              iz:   { monad: true },
              io:     {},
              stack:  {},
              trans:  _funcy( 
               function () {}, 
               { 
                 like: function() {},
                 swap: function() {},
                 just:  _funcy( 
                    function () {}, 
                    {
                     member:  function() {},
                     stack:   function() {},
                     symbols: function() {}
                   }
                 ),
                 compose: _funcy( 
                   function () {}, 
                   { 
                     reflect: function() {},
                     imply:   function() {},
                     glue:    function() {},
                   }
                 ),
                 math: {
                     log:   function() {},
                     ln:    function() {},
                     pow:   function() {},
                     root:  function() {},
                     uminus:function() {},
                     minus: function() {},
                     times: function() {},
                     div:   function() {},
                     mod:   function() {},
                     log:   function() {},
                     ln:    function() {},
                  } //math
                }
              ), //trans
              logic: {
                  n:        function() {},
                  eq:       function() {},
                  neq:      function() {},
                  lte:      function() {},
                  gte:      function() {},
                  gt :      function() {},
                  lt :      function() {},
                  contains: function() {},
                  kin:      function() {}, 
                } //logic
                sym:  function() {},
                make: _funcy( 
                    function() {
                      var ret = {}; 
                      ret.prototype = core.type.monad;
                      ret.io        = core.type.stack.make(/*TODO*/);
                      ret.stack     = core.type.stack.make();
                      return ret;
                    },{ 
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
                ln   : function() {},
                pow  : function() {},
                root : function() {}
              },
            string: {
                haz: { length: function() {}, },
                iz:  { string: true, interpolated: function() {} },
               } //string
            }//type
};  //core
  


//utility function for twiddling inheritance
var _adopt = function() {
  var args = _args(arguments),
      mom  = args.shift(), //mom is first argument 
      kids = args;         //all kids come next
      
      kids.forEach(function(k) { k.prototype = mom; }  
}

//atoms, symbols, stacks and monads are entities
_adopt(core.type.entity, core.type.atom, core.type.symbol, core.type.stack, core.type.monad);

//Numbers, strings, and booleans are atoms
_adopt(core.type.atom, core.type.number, core.type.string, core.type.bool );

//Transforms and symbols are monads
_adopt(core.type.monad, core.type.symbol, core.type.transform );

)();
