angular.module('hoodFrequencyApp').
  factory('frequencyLoader', function(ENV) {
    var loadFrequency = function() {
      return JSON.parse(angular.element("#frequency_values").val());
    };

    return loadFrequency;
  });
