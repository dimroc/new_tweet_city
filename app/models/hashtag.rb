class Hashtag < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :tweet

  def self.backpopulate(start_date)
    Tweet.where("hashtags IS NOT NULL AND hashtags != ''").where('created_at > ?', start_date).find_each do |tweet|
      create_from_tweet(tweet)
    end
  end

  def self.create_from_tweet(tweet)
    prefix =
      "INSERT INTO hashtags (tweet_id, neighborhood_id, borough, term, updated_at, created_at) VALUES \n"
    updated_at = DateTime.now
    borough = tweet.neighborhood.try(:borough)

    suffix = tweet.hashtags.split(',').map do |term|
      sanitize_sql_array([
        "(?,?,?,?,?,?)",
        tweet.id,
        tweet.neighborhood_id,
        borough,
        term,
        updated_at,
        tweet.created_at
      ])
    end.join(",\n")

    connection.execute(prefix + suffix)
  end
end
