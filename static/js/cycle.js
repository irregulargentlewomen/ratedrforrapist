this.randomtip = function() {

	var pause = 3000; // define the pause for each item (in milliseconds) 
	var length = $("li").length;
	var temp = -1;

	this.getRan = function() {
		// get the random number
		var ran = Math.floor(Math.random() * length) + 1;
		return ran;
	};
	this.show = function() {
		var ran = getRan();
		// to avoid repeating
		while (ran == temp) {
			ran = getRan();
		};
		temp = ran;
		$("#excerpts li").hide();
		$("#excerpts li:nth-child(" + ran + ")").fadeIn("slow");
	};

	show();
	setInterval(show, pause);

};

$(document).ready(function() {
	randomtip();
});
