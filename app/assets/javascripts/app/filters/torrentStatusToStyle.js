angular.module('app.filters').filter('torrentStatusToStyle', [function () {
  return function (torrent) {
    if (torrent.percent_done === 100) {
      return 'success';
    }

    if (torrent.status >= 3 && torrent.status <= 6) {
      return 'info';
    }

    return 'default';
  }
}]);
