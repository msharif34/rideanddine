$(function (){

		$('.dropdown-toggle').dropdown();

		$(".first-button").click(function(e) {
			e.preventDefault();
	    $('html, body').animate({
	        scrollTop: $(".texture-overlay").offset().top
	    }, 2000);
	});





	$('.search-button').on('click', function(e){

		if ($('#address').val() || $('#destination').val()  === ''){
			e.preventDefault();
			alert('no input')
		}
		else{
			$('.input-group').fadeOut();
		}
	})
})



