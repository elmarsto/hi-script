

/* mixtress.js
 * licensed under WTFPL 
 */


const jQuery = require('jQuery');
var mixtress = {}; 

(function(){

//this private function produces a real array from an arguments object
_args = function(the_arguments) {
     var ret = [];
     for (var a in the_arguments) { ret.push(a); }
     return ret;
}


mixtress = function() {
   /* step one: get jQuery to do the heavy lifting */
   var target = jQuery.extend.apply(jQuery,arguments);
   /* no step two! */
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


/* takes a function and a JSON object and returns something that is both */
mixtress.funcy = function(f,j) {
    ff = function() { return f.apply(this,arguments); }; // 'forwarding function'
    // return mixtress(ff,j); //WRONG. we want a *shallow* copy.  
    // so let's DIY!
    
    for (p in j) {            //RIGHT
      if (j.hasOwnProperty(p) && 
          j.isEnumerable(p))
        ff[p] = j[p];
    }
    
    return ff;
} 


})();
