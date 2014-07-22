angular.module('hoodFrequencyApp').
  factory('hoodLoader', function(ENV) {
    return _.bind(NTC.Loader.loadHoods, NTC.Loader);
});
