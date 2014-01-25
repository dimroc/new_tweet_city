# reference: http://www.daniel-azuma.com/blog/archives/164
class Mercator
  SRID = 3785

  # This PROJ4 string is actually INCORRECT but
  # because of legacy with my own apps, decided to continue with same projection
  FACTORY = RGeo::Geographic.projected_factory(
        projection_proj4: '+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs',
        projection_srid: 3785,
        srid: 4326)

  class << self
    def to_geographic(geometry)
      FACTORY.unproject geometry
    end

    def to_projected(geometry)
      FACTORY.project geometry
    end
  end
end
