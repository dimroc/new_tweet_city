angular.module('hoodFrequencyApp').
  factory('hoodFrequencyCoordinator', function() {
    var calculator = function (hoods, frequencyMap) {
      var values = [];
      for (var key in frequencyMap) {
        values.push(frequencyMap[key]);
      }

      var totalFrequency = _(values).reduce(function(memo, num) { return memo + num }, 0);
      var maxFrequency = _(values).max();
      console.log("Total Frequency:", totalFrequency);
      console.log("Max Frequency:", maxFrequency);

      var normalizedFrequency = {};
      for (var key in frequencyMap) {
        normalizedFrequency[key] = frequencyMap[key] / maxFrequency;
      }

      var assignFrequency = function(hoods, frequency) {
        _(hoods).each(function(hood) {
          hood.totalFrequency = totalFrequency;
          hood.maxFrequency = maxFrequency;
          hood.frequency = frequencyMap[hood.slug];
          hood.normalizedFrequency = normalizedFrequency[hood.slug];
        });
      };

      assignFrequency(hoods, frequencyMap);
    };

    return calculator;
  });

