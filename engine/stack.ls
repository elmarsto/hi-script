() ->
  out = ->
  props =
    push: ->
    pop:  ->
    drop: ->
    peek: ->
    swap: ->
    content: [ /* populated at runtime */]
  out <<< props
