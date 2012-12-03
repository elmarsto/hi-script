

/* mixtress.js
 * licensed under WTFPL 
 * (C) Undoware 2012 
 */


var mixtress;

(function(){

mixtress = function() {
	var target = arguments.shift(),
	    mixins = arguments;

	for (var mx in mixins) { 
		for (var k in mx) { target[k] = mx[k]; } 
	}

};


mixtress.into = function() {
	var mixin  = arguments.shift(),
       targets = arguments;


	for (var t in targets) {
			mixtress(t,mixin);
	}
}


/* for completeness */
mixtress.above  	= function() { return mixtress.apply(mixtress,arguments); };
mixtress.into.above = function() { return mixtress.into.apply(mixtress,arguments); };


/* when composed, 
 * this private func produces a function to reverse the argument order of a function */
var _belowify = function() {
	var	o = [];
	while (var i = arguments.pop()) { o.push(i); }
	return this(o);		
}

/* like this, see? */

mixtress.beneath = function() {
	return _belowify.apply(mixtress,arguments);
}

mixtress.into.beneath = function() {
	return _belowify.apply(mixtress.into,arguments);
}

})();
