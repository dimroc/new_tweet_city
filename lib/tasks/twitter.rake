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

  desc "generate image based on tweet coordinates"
  task :image => :environment do
    filename = "tmp/tweet_pic_#{Time.now.to_i}.png"
    puts "Generating #{filename}"
    ImageService::Manhattan.new.save filename
  end
end
