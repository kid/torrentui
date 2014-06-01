angular.module('app.filters').filter('torrentActive', [function () {
  return function (torrent) {
    return torrent.status >= 3 && torrent.status <= 6;
  }
}]);
