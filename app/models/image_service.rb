class ImageService
  attr_reader :width, :height

  def initialize(options={})
    @width = options[:width] || 2048
    @height = options[:height] || 2048
    @png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)

    @earliest = options[:begins_at] || Tweet.chronological.first.created_at
    @latest = options[:ends_at] || Tweet.order("created_at DESC").first.created_at

    @mercator_width = @topright.x - @bottomleft.x
    @mercator_height = @topright.y - @bottomleft.y
  end

  def save(filename)
    generate

    @png.save filename
    FileUtils.cp filename, "tmp/latest.png"
  end

  def generate
    raise NotImplementedError, "Must invoke from sub class"
  end

  def set_pixel(tweet)
    pixel_coordinates = [
      map_x(tweet.coordinates),
      map_y(tweet.coordinates)]

    frequency = generate_frequency_color(pixel_coordinates)
    color = ChunkyPNG::Color.rgba(
      frequency,
      0,
      255 - frequency,
      255)

    @png[pixel_coordinates[0], pixel_coordinates[1]] = color

  rescue ChunkyPNG::OutOfBounds => e
    puts e.message
  end

  private

  def map_x(coordinates)
    offset = coordinates.x - @bottomleft.x
    normalized_distance = (offset.to_f / @mercator_height)
    (normalized_distance * @height).to_i
  end

  def map_y(coordinates)
    offset = coordinates.y - @bottomleft.y

    # Intentionally use width again to force same scale
    normalized_distance = (offset.to_f / @mercator_height)
    mapped = (normalized_distance * @height).to_i

    # ChunkyPNG has row 0 at the top, not bottom of image. Flip
    @height - mapped
  end

  def color_age(date)
    offset = date.to_i - @earliest.to_i
    range = @latest.to_i - @earliest.to_i
    ((offset.to_f / range) * 255).to_i
  end

  def generate_frequency_color(pixel_coordinates)
    @frequency_buckets ||= {}
    key = "#{pixel_coordinates[0]},#{pixel_coordinates[1]}".to_sym
    if @frequency_buckets[key]
      @frequency_buckets[key] += 1
    else
      @frequency_buckets[key] = 1
    end

    ((@frequency_buckets[key].to_f / 20) * 255).to_i
  end
end
