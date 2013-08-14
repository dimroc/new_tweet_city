class Borough
  def self.names
    Neighborhood.all.map(&:borough).uniq
  end
end
