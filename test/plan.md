Plans for unit tests
====================

x = require('hi')
echo x(expr) should evaluate expr

y = x.hi()
echo y should have a parselevel one higher than x
assert y.parselevel === x.parselevel+1


x2  = y.bye()
echo x2 should be the same object as x
assert x === x2


