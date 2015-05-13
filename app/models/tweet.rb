require 'elasticsearch/model'

class Tweet < ActiveRecord::Base
  include SearchableTweet

  belongs_to :neighborhood

  scope :chronological, -> { order(:created_at) }
  scope :descending, -> { order('created_at DESC') }
  scope :has_media, -> { where.not(media_type: nil) }
  scope :since_yesterday, -> { where(created_at: 1.day.ago..DateTime.now) }

  class << self
    def create_from_tweet(tweet)
      geographic_point = retrieve_geographic_point(tweet)
      return nil if geographic_point.blank?

      point = Mercator.to_projected(geographic_point)
      neighborhood = Neighborhood.intersects(point).first

      hashtags = retrieve_hashtags(tweet).join(',')
      hashtags = nil unless hashtags.present? # Prevent empty strings '' from entering db

      create(
        screen_name: tweet['user']['screen_name'],
        profile_image_url: tweet['user']['profile_image_url'],
        text: tweet['text'],
        media_url: retrieve_media_url(tweet),
        media_type: retrieve_media_type(tweet),
        hashtags: hashtags,
        geographic_coordinates: geographic_point,
        coordinates: point,
        neighborhood: neighborhood,
        poi: !!poi?(tweet)
      )
    end

    def for_borough(borough)
      Tweet.where(neighborhood_id: Neighborhood.where(borough: borough).map(&:id))
    end

    def within_nyc
      envelope = Mercator::FACTORY.projection_factory.line(Area.nyc_bottom_left, Area.nyc_top_right).envelope
      where("ST_Intersects(ST_GeomFromText('#{envelope.as_text}', #{Mercator::SRID}), coordinates)")
    end

    def within_manhattan
      envelope = Mercator::FACTORY.projection_factory.line(Area.manhattan_bottom_left, Area.manhattan_top_right).envelope
      where("ST_Intersects(ST_GeomFromText('#{envelope.as_text}', #{Mercator::SRID}), coordinates)")
    end

    def reattach_neighborhoods!
      Neighborhood.find_each do |hood|
        connection.execute(<<-SQL)
        UPDATE tweets SET neighborhood_id = #{hood.id}
          WHERE ST_Intersects(ST_AsText(tweets.coordinates), '#{hood.geometry.as_text}')
        SQL

        puts "Finished #{hood.name}"
      end
    end
  end

  private

  class << self
    def retrieve_geographic_point(hash)
      if hash["coordinates"]
        coordinates = hash['coordinates']['coordinates']
        Mercator::FACTORY.point(coordinates[0], coordinates[1])
      elsif (hash["place"] && hash["place"]["bounding_box"] && hash["place"]["place_type"] == "poi")
        polygon = hash["place"]["bounding_box"]["coordinates"]
        points = polygon[0].map { |p| Mercator::FACTORY.point p[0], p[1] }
        lr = Mercator::FACTORY.linear_ring points
        Mercator::FACTORY.polygon(lr).centroid
      else
        nil
      end
    end

    def poi?(hash)
      hash["place"] && hash["place"]["place_type"] == "poi"
    end

    #def has_no_coordinates?(hash)
      #!hash["coordinates"] ||
        #!(hash["place"] && hash["place"]["bounding_box"] && hash["place"]["place_type"] == "poi")
    #end

    def retrieve_media_url(tweet)
      retrieve_media_element(tweet, 'media_url')
    end

    def retrieve_media_type(tweet)
      retrieve_media_element(tweet, 'type')
    end

    def retrieve_hashtags(tweet)
      return [] unless tweet && tweet['entities']

      top = tweet['entities']['hashtags'].map do |entry|
        entry['text']
      end

      rehashed = retrieve_hashtags(tweet['retweeted_status'])
      (top + rehashed).uniq
    end

    def retrieve_media_element(tweet, key)
      return nil unless tweet['entities']
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
