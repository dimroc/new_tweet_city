class Tweet < ActiveRecord::Base
  NYC_BOTTOM_LEFT = Mercator.to_projected(Mercator::FACTORY.point(-74.3, 40.462))
  NYC_TOP_RIGHT = Mercator.to_projected(Mercator::FACTORY.point(-73.65, 40.95))

  MANHATTAN_BOTTOM_LEFT = Mercator.to_projected(Mercator::FACTORY.point(-74.06, 40.675))
  MANHATTAN_TOP_RIGHT = Mercator.to_projected(Mercator::FACTORY.point(-73.74, 40.884))

  def self.create_from_tweet(tweet)
    coordinates = tweet['coordinates']['coordinates']
    geographic_point = Mercator::FACTORY.point(coordinates[0], coordinates[1])

    create(
      text: tweet['text'],
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
end
