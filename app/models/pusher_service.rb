class PusherService
  class << self
    def broadcast_tweet(tweet)
      output = render_tweet(tweet)
      Pusher['global'].trigger('tweet', body: output, neighborhood: tweet.neighborhood.slug)
    rescue => e
      puts "Error pushing tweet: #{e.message}"
    end

    def render_tweet(tweet)
      view = ActionView::Base.new(ActionController::Base.view_paths)
      view.extend ApplicationHelper
      view.render(partial: 'boroughs/tweet', locals: { tweet: tweet })
    end
  end
end
