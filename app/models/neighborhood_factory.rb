class NeighborhoodFactory
  class << self
    def from_shapefile(shapefile)
      require 'rgeo/shapefile'

      factory = Mercator::FACTORY.projection_factory
      RGeo::Shapefile::Reader.open(shapefile, factory: factory) do |file|
        raise ArgumentError, "File contains no records" if file.num_records == 0

        file.each do |record|
          Neighborhood.create!(name: record["NTAName"],
                               borough: record["BoroName"],
                               geometry: record.geometry)

        end
      end
    end
  end
end
