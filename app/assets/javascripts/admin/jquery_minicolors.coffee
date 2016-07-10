ready = ->
	$('input.minicolors').minicolors theme: 'bootstrap'

$(document).ready(ready)
$(document).on('turbolinks:load', ready)