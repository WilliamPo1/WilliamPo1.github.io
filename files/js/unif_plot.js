(function($) {
    $(document).ready(function() {
	
	$('#unif_plot').scianimator({
	    'images': [],
	    'width': 480,
	    'delay': 1000,
	    'loopMode': 'loop'
	});
	$('#unif_plot').scianimator('play');
    });
})(jQuery);
