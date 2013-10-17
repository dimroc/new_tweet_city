class Hashtag < ActiveRecord::Base
  def self.backpopulate(start_date)
    Tweet.where("hashtags IS NOT NULL AND hashtags != ''").where('created_at > ?', start_date).find_each do |tweet|
      create_from_tweet(tweet)
    end
  end

  def self.create_from_tweet(tweet)
    tweet.hashtags.split(',').each do |term|
      Hashtag.create(tweet_id: tweet.id, term: term, created_at: tweet.created_at)
      print '.'
    end
  end
end
