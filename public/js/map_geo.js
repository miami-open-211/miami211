$(document).on("distance:display", function (event){
	if (event && $(event.target).attr("data-id")) {

		var from = [25.850487, -80.191390];
		var to = [
			parseFloat($(event.target).attr("data-latitude")), 
			parseFloat($(event.target).attr("data-longitude"))];

		var distance = turf.distance(from, to, "miles");
		$(event.target).find('.distance').text( distance.toFixed(2) + ' miles' );
	}
});
