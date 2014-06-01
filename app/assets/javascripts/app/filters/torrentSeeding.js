angular.module('app.filters').filter('torrentSeeding', [function () {
  return function (torrent) {
    return torrent.status === 5 || torrent.status === 6;
  }
}]);
