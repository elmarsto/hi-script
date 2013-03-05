->
  out = ->  #TODO
  props =
    parselevel: -1
    parent: null
    sym: {}
    queue: []
    history: []
    iz:
       monad: true
    noop: -> @
    hi: (evaluand) ->  #TODO
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
  for p in <[ like stack just compose math check logic ]>
    out[p] = require(p)()
  out
