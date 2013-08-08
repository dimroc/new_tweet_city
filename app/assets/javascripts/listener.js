NTC.Listener = {
  listenToTweets: function(selector, hoods) {

    NTC.channel.bind('tweet', function(data) {
      var hood = NTC.Listener.belongsToHood(data.neighborhood, hoods);
      if(hood) {
        NTC.Listener.colorHood(hood);
        $(selector).prepend(data.body);
      }
    });
  },

  colorHood: function(hood) {
    _(hood.paths).each(function(path) {
      path.fillColor = 'blue';
    });
  },

  belongsToHood: function(slug, hoods) {
    return _(hoods).detect(function(hood) {
      return hood.slug == slug;
    });
  }
}
