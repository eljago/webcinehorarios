

ready = ->
	$('form').on 'click', '.remove_fields', (event) ->
		$(this).prev('input[type=hidden]').val('1')
		$(this).closest('fieldset').hide()
		event.preventDefault()


$(document).on('turbolinks:load', ready)
$(document).ready(ready)