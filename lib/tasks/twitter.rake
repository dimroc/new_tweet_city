namespace :twitter do
  def run_stream
    TwitterService.new.stream_nyc do |tweet|
      if !tweet["coordinates"]
        print 'M'
        next
      end

      if Tweet.create_from_tweet(tweet)
        print '.'
      else
        print 'F'
      end
    end
  rescue => e
    puts e.message
    puts "sleeping"
    sleep 60
    puts "retrying"
    retry
  end

  desc "Stream tweets from nyc to connected clients"
  task :stream => :environment do
    run_stream
  end
end
