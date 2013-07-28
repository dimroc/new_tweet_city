class Tweet < ActiveRecord::Base
  NYC_BOTTOM_LEFT = Mercator.to_projected(Mercator::FACTORY.point(-74.3, 40.462))
  NYC_TOP_RIGHT = Mercator.to_projected(Mercator::FACTORY.point(-73.65, 40.95))

  MANHATTAN_BOTTOM_LEFT = Mercator.to_projected(Mercator::FACTORY.point(-74.06, 40.675))
  MANHATTAN_TOP_RIGHT = Mercator.to_projected(Mercator::FACTORY.point(-73.74, 40.884))

  scope :chronological, -> { order(:created_at) }

  def self.create_from_tweet(tweet)
    coordinates = tweet['coordinates']['coordinates']
    geographic_point = Mercator::FACTORY.point(coordinates[0], coordinates[1])

    hashtags = retrieve_hashtags(tweet).join(',')
    hashtags = nil unless hashtags.present? # Prevent empty strings '' from entering db

    create(
      text: tweet['text'],
      media_url: retrieve_media_url(tweet),
      media_type: retrieve_media_type(tweet),
      hashtags: hashtags,
      geographic_coordinates: geographic_point,
      coordinates: Mercator.to_projected(geographic_point)
    )
  end

  def self.within_nyc
    envelope = Mercator::FACTORY.projection_factory.line(NYC_BOTTOM_LEFT, NYC_TOP_RIGHT).envelope
    where("ST_Intersects(ST_GeomFromText('#{envelope.as_text}', #{Mercator::SRID}), coordinates)")
  end

  def self.within_manhattan
    envelope = Mercator::FACTORY.projection_factory.line(MANHATTAN_BOTTOM_LEFT, MANHATTAN_TOP_RIGHT).envelope
    where("ST_Intersects(ST_GeomFromText('#{envelope.as_text}', #{Mercator::SRID}), coordinates)")
  end

  private

  class << self
    def retrieve_media_url(tweet)
      retrieve_media_element(tweet, 'url')
    end

    def retrieve_media_type(tweet)
      retrieve_media_element(tweet, 'type')
    end

    def retrieve_hashtags(tweet)
      return [] unless tweet

      top = tweet['entities']['hashtags'].map do |entry|
        entry['text']
      end

      rehashed = retrieve_hashtags(tweet['retweeted_status'])
      (top + rehashed).uniq
    end

    def retrieve_media_element(tweet, key)
      media = tweet['entities']['media']
      type = media[0][key] if media && media[0] && media[0][key]

      if type
        type
      else
        retweet = tweet['retweeted_status']
        retrieve_media_element(retweet, key) if retweet
      end
    end
  end
end
