jQuery ->
	$('.chzn-select').chosen()
	$('#showpersonroles').sortable
		axis: 'y'
		handle: '.handle'
		update: ->
			$.post($(this).data('update-url'), $(this).sortable('serialize'))