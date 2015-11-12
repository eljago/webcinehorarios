$(document).ready(function(){
	var button = $('#contact').find('button');
  button.button();

  button.click(function() {
    $(this).button('loading');
  });
	
  // Hide alert messages after timeout
/*  setTimeout(function() {
		$(".alert").fadeTo(500, 0).slideUp(500, function(){
			$(this).remove();
		});
	}, 1000);*/

	$(".features-scroll").on( "click", function() {
    var divLoc = $('#features').offset();
    $('html, body').animate({scrollTop: divLoc.top - 50}, "slow");
	});
	$(".contact-scroll").on( "click", function() {
    var divLoc = $('#contact').offset();
    $('html, body').animate({scrollTop: divLoc.top}, "slow");
	});
	$(".top-scroll").on( "click", function() {
    $('html, body').animate({scrollTop: 0}, "slow");
	});
	
	$('.list-group-item').click(function (e) {
	  e.preventDefault();
		$('.list-group-item').filter('.active').removeClass('active');
	  $(this).addClass('active');
	});

	$('#desc-favoritos, #desc-cartelera, #desc-proximamente, #desc-detalle, #desc-mapa, #desc-media').hide();
	
	$.each([ "cines", "favoritos", "mapa", "cartelera", "proximamente", "detalle", "media" ], function( index, value ) {
		$('#lgi-'+value).click(function (e) {
		  e.preventDefault();
			$('.lgi-desc').hide();
		  $("#desc-"+value).fadeIn();
		});
	});
});
