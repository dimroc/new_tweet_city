class Neighborhood < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :tweets

  validates_presence_of :name, :borough, :geometry, :slug

  scope :manhattan, -> { where(borough: "Manhattan") }
  scope :brooklyn, -> { where(borough: "Brooklyn") }

  class << self
    def intersects(geom)
      where(<<-SQL, geom.as_text, geom.srid)
        ST_Intersects(neighborhoods.geometry, ST_GeomFromText(?, ?))
      SQL
    end

    def lower_east_side
      find_by_name("Lower East Side")
    end

    def west_village
      find_by_name("West Village")
    end

    def generate_cache
      Neighborhood.all.inject({}) do |memo, hood|
        memo[hood.id] = hood
        memo
      end
    end
  end

  def as_json(options = {})
    hash = super(options)
    hash.merge!('geometry' => RGeo::GeoJSON.encode(geometry)) if hash['geometry']
    hash
  end
end
