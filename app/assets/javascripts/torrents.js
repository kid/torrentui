$(document).ready(function() {
	$("#torrents").tablesorter({});

	// Initialize the jQuery File Upload widget:
	$('#fileupload').fileupload({
		acceptFileTypes: /\.torrent/i,

		stop: function (e, data) {
			window.location.reload();
		}
	});
});