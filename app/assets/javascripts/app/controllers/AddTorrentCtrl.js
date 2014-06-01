angular
    .module('app.controllers')
    .controller('AddTorrentCtrl', ['$scope', '$upload', 'files', function ($scope, $upload, files) {

    	window.$scope = $scope;

    	$scope.files = files;

        // $scope.onFileSelect = function($files) {
        //     $scope.files = $files;
        // };

        $scope.submit = function () {
        	for (var i = 0; i < $scope.files.length; i++) {
        		var file = $scope.files[i];

        		$upload
        			.upload({
        				url: '/torrents',
        				data: {
        					torrent: {},
        				},
        				file: file
        			})
        			.success(function () {
        				console.log('ok');
        			});
        	}
        };

    }]);