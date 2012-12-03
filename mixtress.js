

/* mixtress.js
 * licensed under WTFPL 
 */


const jsonselect = require('JSONSelect');
var mixtress = {}; 

(function(){

//this private function produces a real array from an arguments object
_args = function(the_arguments) {
     var ret = [];
     for (var a in the_arguments) { ret.push(a); }
     return ret;
}


mixtress = function() {
   var target = jQuery.extend.apply(jQuery,arguments);
   var mixins   = _args(arguments).slice(1);

   jsel.forEach(":has(:root > '.')", target, function(elt) {
                  var f = elt['.'];
                  var n = function() { return f.apply(this,arguments); };
                  elt['.'] = undefined;
                  elt = jQuery.extend(n,elt); /* this works, because elt is a reference, right? */
                  /*discard return value, because it's ignored*/
                  /*WARNING BROKEN because this dynamically changes the tree in ways that jsel.forEach is unaware of; FIXME */
              });

   return target;
};


mixtress.into = function() {
  var args   = _args(arguments),
     mixin  =  args.shift();
   for (var t in args) { t = mixtress(t,mixin); }
}


/* for completeness */
mixtress.above      = function() { return mixtress.apply(mixtress,arguments); };
mixtress.into.above = function() { return mixtress.into.apply(mixtress,arguments); };


/* masala... */
var _neath = function() {
   var args = _args(arguments), 
     newb = {},
     subj = args[0];
   newb.prototype = subj.prototype; //make empty object of the same type as original subject

                    //move over any executability
   if (typeof subj === 'function')  { newb = subj.bind(newb); }
   
   args.push(newb);         //add newbie to end of arguments array
   args.reverse();          //reverse array. newb is now the new
                  //subject. Properties of subj copied as last mixin. 
                  //TODO function rebinding; until then,
                  //don't use directly on a function! 
                  //(properties of an object which contain functions are fine)
                    
   return this.apply(this,args);
}

/* ...for currying, like this, see? */

mixtress.beneath    = function() { return _neath.apply(mixtress,arguments); }
mixtress.into.beneath = function() { return _neath.apply(mixtress.into,arguments); }

})();
