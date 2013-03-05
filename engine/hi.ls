() ->
  out = {}
  out[p] = require(p)() for p in <[ constant type ]>
  out
