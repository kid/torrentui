angular.module('app.filters').filter('bytes', [function () {
  return function(bytes, precision) {
    if (isNaN(parseFloat(bytes)) || !isFinite(bytes)) return '-';

    if (typeof precision === 'undefined') precision = 1;

    if (bytes == 0 || isNaN(parseFloat(bytes)) || !isFinite(bytes)) return '-';

    var units = ['B', 'Kb', 'mb', 'Gb', 'Tb', 'Pb'];
    var number = Math.floor(Math.log(bytes) / Math.log(1024));

    return (bytes / Math.pow(1024, Math.floor(number))).toFixed(precision) + ' ' + units[number];
  }
}]);
