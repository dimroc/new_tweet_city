class Borough
  NAMES = Neighborhood.all.map(&:borough).uniq
end
