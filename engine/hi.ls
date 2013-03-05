for p in <[ constant type ]>
   exports[p] = require(p)
exports.hi  = -> exports.type.monad.hi(...)
exports.bye = -> exports.type.monad.bye(...)
