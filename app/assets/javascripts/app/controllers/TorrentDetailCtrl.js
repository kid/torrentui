angular
  .module('app.controllers')
  .controller('TorrentDetailCtrl', ['$scope', 'torrent', function ($scope, torrent) {
    console.log(torrent);
    $scope.torrent = torrent;
  }]);
