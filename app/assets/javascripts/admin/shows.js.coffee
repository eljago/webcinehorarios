func = (e) ->
	id = e.val()
	e.select2
		minimumInputLength: 3
		ajax:
			url: e.data('source')
			dataType: 'json'
			data: (term) ->
				q: term
			results: (data) ->
				results: data.shows

		initSelection: (element, callback) ->
			id = $(element).val()
			if id isnt ""
				$.ajax("/admin/shows/" + id + "/simple_show.json",
					dataType: "json"
				).done (data) ->
					callback
						id: id
						text: data.show.name

ready = ->
	$('.shows-select').each (i, e) =>
		func($(e))
	$('.chzn-select').select2({ width: 'resolve' });   

$(document).ready(ready)