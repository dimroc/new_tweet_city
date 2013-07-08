# reference: http://www.daniel-azuma.com/blog/archives/164
class Mercator
  SRID = 3857

  # TODO: Figure out why this is different to the default simple_mercator_factory
  FACTORY = RGeo::Geographic.projected_factory(
        projection_proj4: "+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378137 +b=6378137 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs",
        projection_srid: 3857,
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
