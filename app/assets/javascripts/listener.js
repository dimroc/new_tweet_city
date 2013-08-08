NTC.Listener = {
  listenToTweets: function(selector, hoods) {

    NTC.channel.bind('tweet', function(data) {
      if(NTC.Listener.belongsToHood(data.neighborhood, hoods)) {
        $(selector).prepend(data.body);
      }
    });
  },

  belongsToHood: function(slug, hoods) {
    return _(hoods).detect(function(hood) {
      return hood.slug == slug;
    });
  }
}
