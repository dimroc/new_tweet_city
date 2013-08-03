Neighborhood.connection.execute(<<-SQL) #postgres specific
TRUNCATE neighborhoods RESTART IDENTITY;
SQL

NeighborhoodFactory.from_shapefile("lib/data/shapefiles/neighborhoods/neighborhood")
