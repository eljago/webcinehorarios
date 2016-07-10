func = (e) ->
	id = $(e).val()
	$(e).select2
		minimumInputLength: 3
		placeholder: 'Buscar personas'
		ajax:
			url: $(e).data('source')
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
	$('form').on 'click', '.add_fields', (event) ->
		time = new Date().getTime()
		regexp = new RegExp($(this).data('id'), 'g')
		$(this).before($(this).data('fields').replace(regexp, time))
		if $('fieldset.show_person_role:last .people-select').length
			func($('fieldset.show_person_role:last .people-select'))
		event.preventDefault()

$(document).on('turbolinks:load', ready)
$(document).ready(ready)