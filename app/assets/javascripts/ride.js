$(function (){

		$('.dropdown-toggle').dropdown();

		$(".first-button").click(function(e) {
			e.preventDefault();
	    $('html, body').animate({
	        scrollTop: $(".features-intro").offset().top
	    }, 2000);
	});

	$('.search-button').on('click', function(e){

		
		console.log('clicked');
		$('.input-group').fadeOut();
	})
})