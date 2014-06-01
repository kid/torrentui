angular
  .module('app.controllers')
  .controller('TorrentListCtrl', ['$scope', '$state', '$stateParams', '$modal', '$http', function ($scope, $state, $stateParams, $modal, $http) {

    var makeFilter = function (status) {
      return function (item) {
        for (var i = 0; i < status.length; i++) {
          if (item.status === status[i]) {
            return true;
          }
        }

        return false;
      };
    };

    $scope.tabs = {
      all: { filter: function () { return true; } },
      downloading: { filter: makeFilter([3, 4]) },
      seeding: { filter: makeFilter([5, 6]) },
      paused: { 
        filter: function (item) {
          var statusFilter = makeFilter([0]);
          return item.percent_done !== 100 && statusFilter(item);
        } 
      },
      completed: { 
        filter: function (item) {
          return item.percent_done === 100;
        }
      }
    };

    $scope.activeTab = $stateParams.tab || 'all';
    $scope.filterText = '';
    $scope.orderBy = 'name';
    $scope.orderReversed = false;
    
    $scope.setActiveTab = function (tab) {
      $scope.activeTab = tab;
      $state.go('torrent.list', {tab: tab}, {notify: false});
    };

    $scope.filter = function (item) {
      return item.name.toLowerCase().indexOf($scope.filterText.toLowerCase()) > -1 && $scope.tabs[$scope.activeTab].filter(item);
    };

    $scope.onFileDropped = function (files) {
      var modalInstance = $modal.open({
        templateUrl: 'torrent/add.html',
        controller: 'AddTorrentCtrl',
        resolve: {files: function () { return files; }}
      });
    };

    $scope.refresh = function () {
      $scope.refreshActive = true;
      $http.get('/torrents')
        .success(function (data) {
          $scope.torrents = data;
          $scope.refreshActive = false;
        });
    };

    $scope.refresh();

    window.$scope = $scope;

  }]);
