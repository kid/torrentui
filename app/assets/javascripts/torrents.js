$(document).ready(function() {
	$("#torrents").tablesorter({});

	var fileUploadErrors = {
		maxFileSize: 'File is too big',
		minFileSize: 'File is too small',
		acceptFileTypes: 'Filetype not allowed',
		maxNumberOfFiles: 'Max number of files exceeded',
		uploadedBytes: 'Uploaded bytes exceed file size',
		emptyResult: 'Empty file upload result'
	};

	// Initialize the jQuery File Upload widget:
	$('#fileupload').fileupload({
		acceptFileTypes: /\.torrent/i,

		drop: function (e, data) {
			// $('#new-torrent-dialog').modal();
		},
		done: function (e, data) {
			console.log("done");
		},
		stop: function (e, data) {
			window.location.reload();
		}
	});
});