class Frequency
  attr_reader :borough, :q

  def self.default
    new("manhattan", "knicks")
  end

  def initialize(borough, terms)
    @borough = validate_borough(borough)
    @q = terms
  end

  def results
    @results ||= Tweet.search_count_in(borough, q)
  end

  private

  def validate_borough(borough_param)
    raise ArgumentError, "invalid borough: #{borough_param}" unless Borough.has? borough_param
    borough_param
  end
end
