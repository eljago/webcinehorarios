$(document).ready(function(){
	var button = $('#contact').find('button');
  button.button();

  button.click(function() {
    $(this).button('loading');
  });  
});