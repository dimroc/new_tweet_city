class ColorStrategy
  def initialize
    @frequency_buckets = {}
  end

  def generate(pixel_coordinates)
    frequency = generate_frequency_color(pixel_coordinates)
    ChunkyPNG::Color.rgba(
      frequency,
      0,
      255 - frequency,
      255)
  end

  private

  attr_reader :frequency_buckets

  def generate_frequency_color(pixel_coordinates)
    key = "#{pixel_coordinates[0]},#{pixel_coordinates[1]}".to_sym
    if frequency_buckets[key]
      frequency_buckets[key] += 1
    else
      frequency_buckets[key] = 1
    end

    ((frequency_buckets[key].to_f / 20) * 255).to_i
  end
end
