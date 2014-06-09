angular
  .module('app.resources')
  .factory('Torrents', ['Restangular', function (Restangular) {
    return Restangular.all('torrents');
  }]);
