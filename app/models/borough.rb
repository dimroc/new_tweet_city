class Borough
  def self.names
    Neighborhood.all.map(&:borough).uniq
  end

  def self.has?(borough)
    names.map(&:downcase).include? borough
  end
end
