class ImageService
  attr_reader :width, :height

  def initialize(options={}, color_strategy = ColorStrategy.new)
    @width = options[:width] || 2048
    @height = options[:height] || 2048
    @png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)
    @color_strategy = color_strategy

    @earliest = options[:begins_at] || Tweet.chronological.first.created_at
    @latest = options[:ends_at] || Tweet.order("created_at DESC").first.created_at

    @mercator_width = @topright.x - @bottomleft.x
    @mercator_height = @topright.y - @bottomleft.y
  end

  def save(filename)
    generate
    @png.save filename
  end

  def generate
    raise NotImplementedError, "Must invoke from sub class"
  end

  def set_pixel(tweet)
    pixel_coordinates = [
      map_x(tweet.coordinates),
      map_y(tweet.coordinates)]

    color = @color_strategy.generate(pixel_coordinates)
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
end
