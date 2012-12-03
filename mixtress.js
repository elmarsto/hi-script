

/* mixtress.js
 * licensed under WTFPL 
 * (C) Undoware 2012 
 */


var mixtress = {}; 

(function(){

//this private function produces a real array from an arguments object
_args = function(the_arguments) {
         var ret = [];
         for (var a in the_arguments) { ret.push(a); }
         return ret;
}


mixtress = function() {
   var args   = _args(arguments),
      target =  args.shift();

   for (var mx in args) { 
      for (var k in mx) {
            switch(k) {
               case '.': target[k] = mx[k].bind(target[k]); break; 
               default:  target[k] = mx[k]; //shallow copy, and naive about inherited props
            }
      } 
   }
   return target;
};


mixtress.into = function() {
    var args   = _args(arguments),
       mixin  =  args.shift();
   for (var t in args) { t = mixtress(t,mixin); }
}


/* for completeness */
mixtress.above    = function() { return mixtress.apply(mixtress,_args(arguments)); };
mixtress.into.above = function() { return mixtress.into.apply(mixtress,_args(arguments)); };


/* masala... */
var _neath = function() {
   var   args = _args(arguments), 
      newb = {},
      subj = args[0];
   newb.prototype = subj.prototype; //make empty object of the same type as original subject
   args.push(newb);                 //add to end of array
   args.reverse();                  //reverse array. newb is now the new
                                    //subject. Properties of subj copied as last mixin. 
                                    //TODO function rebinding; until then,
                                    //don't use directly on a function! 
                                    //(properties of an object which contain functions are fine)
   return this.apply(this,args);
}

/* ...for currying, like this, see? */

mixtress.beneath      = function() { return _neath.apply(mixtress,arguments); }
mixtress.into.beneath = function() { return _neath.apply(mixtress.into,arguments); }

})();
