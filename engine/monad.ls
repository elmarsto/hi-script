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
  like: -> @
exports <<< props
for p in <[ stack just compose math check logic ]>
  exports[p] = require(p)
