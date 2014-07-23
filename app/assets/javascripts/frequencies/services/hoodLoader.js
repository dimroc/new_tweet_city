angular.module('hoodFrequencyApp').
  factory('hoodLoader', ['ENV', function(ENV) {
    return _.bind(NTC.Loader.loadHoods, NTC.Loader);
}]);
