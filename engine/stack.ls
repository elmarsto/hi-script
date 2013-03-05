props =
  push: ->
  pop:  ->
  drop: ->
  peek: ->
  swap: ->
  content: [ /* populated at runtime */]
  thunk: -> console.log('got thunk')
  value: -> console.log('got value')
exports <<< props
