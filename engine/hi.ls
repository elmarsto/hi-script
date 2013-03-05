out = {}
for p in <[ constant type core ]>
  out[p] = require(p)()
out
out.hi  = -> out.type.monad.hi(...)
out.bye = -> out.type.monad.bye(...)
out.type.monad.core = out.core
