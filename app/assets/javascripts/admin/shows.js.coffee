ready = ->
	$('.chzn-select').chosen()
	$('#showpersonroles').sortable
		axis: 'y'
		handle: '.handle'
		update: ->
			$.post($(this).data('update-url'), $(this).sortable('serialize'))
			
$(document).ready(ready)
$(document).on('page:load', ready)