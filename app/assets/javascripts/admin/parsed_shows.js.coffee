ready = ->
	$('.button-parsed-shows').on 'click', (event) ->
		$("[type=checkbox]").click

$(document).ready(ready)
$(document).on('turbolinks:load', ready)