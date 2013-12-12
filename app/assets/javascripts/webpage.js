$(document).ready(function(){
	var button = $('#contact').find('button');
  button.button();

  button.click(function() {
    $(this).button('loading');
  });
	
  // Hide alert messages after timeout
  setTimeout(function() {
		$(".alert").fadeTo(500, 0).slideUp(500, function(){
			$(this).remove();
		});
	}, 1000);
});