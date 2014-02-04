NTC.Listener = {
  listenToTweets: function(selector, borough, hoods, only_media) {
    var channel = 'tweet:' + borough.toLowerCase();

    NTC.channel.bind(channel, function(data) {
      var hood = NTC.Listener.belongsToHood(data.neighborhood, hoods);
      var should_show = (only_media == "true" && data.media_type) || only_media != 'true'

      if(hood && should_show) {
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
