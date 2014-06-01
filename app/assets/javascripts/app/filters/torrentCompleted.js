angular.module('app.filters').filter('torrentCompleted', [function () {
  return function (torrent) {
    return torrent.percent_done === 100;
  }
}]);
