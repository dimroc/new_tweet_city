class PusherService
  class << self
    def broadcast_tweet(tweet)
      output = render_tweet(tweet)
      Pusher['global'].trigger(
        'tweet',
        body: output,
        neighborhood: tweet.neighborhood.slug,
        media_type: tweet.media_type
      )
    rescue => e
      puts "Error pushing tweet: #{e.message}"
    end

    def render_tweet(tweet)
      view = ActionView::Base.new(ActionController::Base.view_paths)
      view.class_eval do
        include Rails.application.routes.url_helpers
        include ApplicationHelper

        def protect_against_forgery?
          false
        end

        if Rails.env.development? || Rails.env.test?
          def default_url_options
            {host: 'localhost:3000'}
          end
        end
      end

      view.render(partial: 'boroughs/tweet', locals: { tweet: tweet })
    end
  end
end
