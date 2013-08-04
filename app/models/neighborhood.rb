class Neighborhood < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  validates_presence_of :name, :borough, :geometry, :slug

  class << self
    def intersects(geom)
      where(<<-SQL, geom.as_text)
        ST_Intersects(ST_AsText(neighborhoods.geometry), ?)
      SQL
    end
  end
end
