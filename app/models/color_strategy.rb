class ColorStrategy
  START_COLOR = Color::RGB.from_html("#a5cbef")
  TARGET_COLOR = Color::RGB::DarkBlue

  def initialize
    @frequency_buckets = {}
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

  attr_reader :frequency_buckets

  def generate_frequency_color(pixel_coordinates)
    key = "#{pixel_coordinates[0]},#{pixel_coordinates[1]}".to_sym
    if frequency_buckets[key]
      frequency_buckets[key] += 1
    else
      frequency_buckets[key] = 1
    end

    percentage = frequency_buckets[key].to_f / 50 * 100
    TARGET_COLOR.mix_with(START_COLOR, percentage)
  end
end
