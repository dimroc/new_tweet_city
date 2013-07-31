namespace :twitter do
  def run_stream
    while(true) do
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

      puts "ENDED at #{DateTime.now}"
      sleep 60
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
    run_stream
  end
end
