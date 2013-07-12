namespace :twitter do
  desc "Stream tweets from nyc to connected clients"
  task :stream => :environment do
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
  end

  desc "generate image based on tweet coordinates"
  task :image => :environment do
    filename = "tmp/tweet_pic_#{Time.now.to_i}.png"
    puts "Generating #{filename}"
    TweetImageService.new(2048, 2048).save filename
  end
end
