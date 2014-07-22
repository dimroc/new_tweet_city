angular.module('hoodFrequencyApp')
  .directive('renderer', ['hoodLoader', 'hoodRenderer', 'frequencyLoader', 'hoodFrequencyCoordinator',
             function (hoodLoader, hoodRenderer, frequencyLoader, hoodFrequencyCoordinator) {
    return {
      restrict: 'A',
      template: '<canvas class=\'hoods\'></canvas>',
      link: function (scope, elem) {
        hoodLoader(scope.hoods).done(function(hoods) {
          hoodFrequencyCoordinator(hoods, frequencyLoader());
          hoodRenderer(scope, hoods, elem.find('canvas')[0]);
        });
      }
    };
  }]);

