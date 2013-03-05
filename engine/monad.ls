() ->
  out = ->  -- TODO
  props =
    parselevel: -1
    parent: null
    sym: {}
    queue: []
    history: []
    iz:
       monad: true
    noop: -> @
    hi: (x) ->  --TODO
    bye: ->
      @parselevel--
      @parent
    force: -> @
    send: ->
      @parent.stack.shift(@stack.pop())
      @
    recv: ->
      @stack.unshift(@parent.stack.pop())
      @
  out <<< props
  out[p] = require(p)() for p in <[ like stack just compose math check logic ]>
  out
