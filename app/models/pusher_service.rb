class PusherService
  class << self
    def broadcast_tweet(tweet)
      output = render_tweet(tweet)
      channel = "tweet:#{tweet.neighborhood.borough.downcase}"

      Pusher['global'].trigger(
        channel,
        body: output,
        neighborhood: tweet.neighborhood.slug,
        media_type: tweet.media_type)
    rescue => e
      puts "Error pushing tweet: #{e.message}"
    end

    def render_tweet(tweet)
      view = TweetView.new(ActionController::Base.view_paths)
      view.render(partial: 'boroughs/tweet', locals: { tweet: tweet })
    end
  end

  private

  class TweetView < ActionView::Base
    include Rails.application.routes.url_helpers
    include ApplicationHelper

    def protect_against_forgery?
      false
    end

    def default_url_options
      if Rails.env.production?
        {host: "newtweetcity.com"}
      else
        {host: 'localhost:3000'}
      end
    end
  end
end
