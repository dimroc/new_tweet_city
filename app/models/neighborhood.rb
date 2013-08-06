class Neighborhood < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :tweets

  validates_presence_of :name, :borough, :geometry, :slug

  class << self
    def intersects(geom)
      where(<<-SQL, geom.as_text)
        ST_Intersects(ST_AsText(neighborhoods.geometry), ?)
      SQL
    end
  end

  def as_json(options = {})
    hash = super(options)
    hash.merge!('geometry' => RGeo::GeoJSON.encode(geometry)) if hash['geometry']
    hash
  end
end
