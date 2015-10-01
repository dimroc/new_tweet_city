namespace :twitter do
  def run_stream
    puts "STARTED at #{DateTime.now}"

    while(true) do
      TwitterService.new.stream_nyc do |hash|
        #if !hash["coordinates"]
          #print 'M'
          #next
        #end

        tweet = Tweet.create_from_tweet(hash)
        if tweet && tweet.neighborhood
          Hashtag.create_from_tweet(tweet) if tweet.hashtags.present?
          PusherService.broadcast_tweet(tweet)
          print '.'
        elsif tweet
          print 'S'
        else
          print 'F'
        end
      end

      puts "ENDED at #{DateTime.now}"
      sleep 30
      puts "retrying at #{DateTime.now}"
    end
  rescue => e
    puts "ERRORED at #{DateTime.now}"
    puts e.message
    sleep 60
    puts "retrying at #{DateTime.now}"
    retry
  end

  desc "Stream tweets from nyc to connected clients"
  task :stream => :environment do
    %w{render_template render_partial render_collection}.each do |event|
      ActiveSupport::Notifications.unsubscribe "#{event}.action_view"
    end

    run_stream
  end

  desc "Associate all tweets with a neighborhood. Long operation."
  task :reattach_neighborhoods => :environment do
    Tweet.reattach_neighborhoods!
  end

  task :prune_old => :environment do
    d = 3.months.ago
    Tweet.where('created_at < ?', d).delete_all
    Tweet.__elasticsearch__.delete_index!
    Tweet.__elasticsearch__.create_index!
    Tweet.import
  end
end
