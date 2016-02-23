func = (e) ->
	id = e.val()
	e.select2
		minimumInputLength: 3
		placeholder: 'Buscar personas'
		ajax:
			url: e.data('source')
			dataType: 'json'
			data: (term) ->
				q: term
			results: (data) ->
				results: data.people

		initSelection: (element, callback) ->
			id = $(element).val()
			if id isnt ""
				$.ajax("/admin/people/" + id + ".json",
					dataType: "json"
				).done (data) ->
					callback
						id: id
						text: data.person.name

ready = ->
	$('.people-select').each (i, e) =>
		func($(e))

	$('#show_person_roles').sortable
		axis: 'y'
		handle: '.handle'
		update: ->
			$.post($(this).data('update-url'), $(this).sortable('serialize'))

$(document).ready(ready)