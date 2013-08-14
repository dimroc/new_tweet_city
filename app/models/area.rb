class Area
  NAMES = %W(manhattan nyc)

  class << self
    def nyc_bottom_left
      Mercator.to_projected(Mercator::FACTORY.point(-74.3, 40.462))
    end

    def nyc_top_right
      Mercator.to_projected(Mercator::FACTORY.point(-73.65, 40.95))
    end

    def manhattan_bottom_left
      Mercator.to_projected(Mercator::FACTORY.point(-74.06, 40.675))
    end

    def manhattan_top_right
      Mercator.to_projected(Mercator::FACTORY.point(-73.74, 40.884))
    end
  end
end
