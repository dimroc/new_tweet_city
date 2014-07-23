angular.module('hoodFrequencyApp')
  .controller('MainCtrl', ['$scope', 'hoodDirectory', function ($scope, hoodDirectory) {
    $scope.hoods = hoodDirectory.hoods();

    $scope.tailStyle = {visibility: 'hidden'};
    $scope.updateTail = function(event) {
      if (this.hood) {
        this.tailStyle = {left: event.pageX + 20, top: event.pageY};
      } else {
        this.tailStyle = {visibility: 'hidden'};
      }
    };

    $scope.$on('hood.selected', function(event, hood) {
      event.currentScope.hood = hood;
    });

    $scope.$on('hood.deselected', function(event) {
      event.currentScope.hood = null;
    });
  }]);
