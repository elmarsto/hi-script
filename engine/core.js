
//TODO break this up into multiple files, it's way too long
//TODO write mixtress.js
//TODO finish stubbing out the parser

require ('mixtress.js')

/* TODO mixtress api
 * mixtress(...) or for some mixtress-produced object, .mix(...)
  '.' on skeletons is the func of a func obj (so e.g. {'.': function(){}) mixed onto .trans makes .trans() )
  .mix on all produced objects
  x.mix(y,y2..) or mixtress(x,y) sucessively copies y, y2... onto x
  y.mix.into(x, x2, ...) copies y onto  x , x1, ...

  x.mix.above(y) and y.mix.into.above(x) both make explicit that in collision, the y-elts are kept, x-elts discarded (default)
  x.mix.below(y) and y.mix.into.below(x) both have the opposite behaviour, rebasing x on y.
*/

/* step one: declare the namespace object. */ 
core = mixtress({ 
                make: {
                        '.': function() {}, //override default constructor to generate instances, not copies of namespace
                        bool: function (x) {}
                        number: function (x) {}
                        string: function (x) {}
                        atom: function(x) {},
                        monad: function(x) {}
                       },
                constant: function (x){},
                type: {
                        '.': function() {},
                        entity: {
                                   is: function() {},
                                },
                        atom: { 
                                has: { value: function() {}, },
                              },
                        symbol: {
                                is: {
                                        declared: function() {},
                                        empty: function() {},
                                    }
                                has: { 
                                        referent: function() {},
                                        literal: function() {},
                                },
                        },
                        monad: { //TODO refactor into separate file
                            io: {},
                            stack: {},
                            trans:  {
                               '.' : function() {},
                               like: function() {},
                               swap: function() {},
                               just:{
                                       member: function() {},
                                       stack: function() {},
                                       symbols: function() {},

                                     },
                               compose: {
                                       reflect: function() {},
                                       imply: function() {},
                                       glue: function() {},
                                     },

                               math: {
                                       log: function() {},
                                       ln:  function() {},
                                       pow: function() {},
                                       root: function() {},
                                       uminus: function() {},
                                       minus: function() {},
                                       times: function() {},
                                       div: function() {},
                                       mod: function() {},
                                       log: function() {},
                                       ln: function() {},
                                  }
                               logic: {
                                      eq: function() {},
                                      neq: function() {},
                                      lte: function() {},
                                      gte: function() {},
                                      gt : function() {},
                                      lt : function() {},
                                      contains: function() {},
                                      kin: function() {}, 
                                     }
                              } //trans
                              sym:  function() {},
                              make: { 
                                      bool: function() {},
                                      string: function() {},
                                      number: function() {},
                                      object: function() {},
                                      array: function() {},
                                  } 
                          } //monad
                        stack: {
                                   has { depth: function() {} },
                                   is { empty: function() {} },
                                   push: function() {},
                                   pop: function() {},
                                   drop: function() {},
                                   peek: function() {},
                               },
                        transform: {
                                   is { forced: function() {} },
                                   wants: function() {},
                                   must: function() {},

                               },
                        number: {
                                is: { 
                                        exactly: function() {},
                                        equalTo: function() {},
                                },
                                plus: function() {},
                                minus: function() {},
                                times: function() {},
                                div  : function() {},
                                mod  : function() {},
                                log  : function() {},
                                ln   : function() {},
                                pow  : function() {},
                                root : function() {}
                                },
                        constant: {
                                is: { 
                                        approximate: function() {},
                                        exactly: function() {},
                                     },
                                 },
                                },
                        string: {
                                has: { 
                                        length: function() {},
                                     },
                                is: { 
                                        interpolated: function() {},
                                     },
                                 }
                        }//type
                }); 
  


/* Step II: Use the mixtress lib to use mixins to provide cheap inheritancelike behaviours and properties */
mixtress.into.above({ is: { forced: true } },
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
                    core.type.monad.trans.just.symbols,
                    core.type.moand.trans.just.stack,
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
                    core.type.atom);

mixtress.into.above({ is: { forced: false } },
                core.type.monad,
                core.type.monad.trans.compose,
                core.type.monad.trans.compose.reflect,
                core.type.monad.trans.compose.imply,
                core.type.monad.trans.compose.glue,
                core.type.monad.trans.just);

//atoms, symbols, stacks and monads are entities
core.type.entity.mix.into.beneath( core.type.constant,
                                   core.type.atom,
                                   core.type.symbol,
                                   core.type.stack,
                                   core.type.monad);

//Numbers, strings, and booleans are atoms
core.type.atom.mix.into.beneath( core.type.number,
                                 core.type.string,
                                 core.type.bool);

//Transforms and symbols are monads
core.type.monad.mix.into.beneath(core.type.symbol,
                                 core.type.transform);

