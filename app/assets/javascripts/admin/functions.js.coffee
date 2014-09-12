func = (e) ->
	id = $(e).val()
	$(e).select2
		minimumInputLength: 3
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
					return
			return
			
jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    func($('fieldset.show_person_role:last .chzn-select'))
    event.preventDefault()