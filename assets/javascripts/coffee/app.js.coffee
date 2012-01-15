#= require lib/jquery
#= require lib/popover
#= require lib/twipsy
window.RatPack = class window.RatPack unless window.RatPack?
$ -> 
  $('button[href]').live 'click', (e) ->
    window.location.href = $(e.target).attr('href') 
  $("[rel=tooltip]").twipsy(
    offset: 20
  ).click( (e) ->
    e.preventDefault()
  )
  $("[rel=popover]").popover(
    offset: 10
    placement: 'below'
    live: true
  ).click( (e) ->
    e.preventDefault()
  )
  
window.RatPack.templates = {
  hello: (person) -> "<h1>Hello, #{person}</h1>"
}
