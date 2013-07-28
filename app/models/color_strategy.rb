class ColorStrategy
  def initialize(profile = ColorStrategy::GreenRed.new)
    @frequency_buckets = {}
    @profile = profile
  end

  def generate(pixel_coordinates)
    frequency = generate_frequency_color(pixel_coordinates)
    ChunkyPNG::Color.rgba(
      frequency.red().to_i,
      frequency.green().to_i,
      frequency.blue().to_i,
      255)
  end

  private

  attr_reader :frequency_buckets, :profile

  def generate_frequency_color(pixel_coordinates)
    key = "#{pixel_coordinates[0]},#{pixel_coordinates[1]}".to_sym
    if frequency_buckets[key]
      frequency_buckets[key] += 1
    else
      frequency_buckets[key] = 1
    end

    percentage = frequency_buckets[key].to_f / 50 * 100
    profile.target.mix_with(profile.start, percentage)
  end
end
