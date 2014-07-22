angular.module('hoodFrequencyApp').
  factory('hoodDirectory', function() {
    return { hoods: function() { return JSON.parse(angular.element("#hood_values").val()); } };
});
