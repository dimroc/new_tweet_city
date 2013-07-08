class TweetImageService
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)

    @mercator_width = Tweet::NYC_TOP_RIGHT.x - Tweet::NYC_BOTTOM_LEFT.x
    @mercator_height = Tweet::NYC_TOP_RIGHT.y - Tweet::NYC_BOTTOM_LEFT.y
  end

  def save(filename)
    Tweet.within_nyc.find_each do |tweet|
      set_pixel tweet
    end

    @png.save filename
  end

  private

  def set_pixel(tweet)
    @png.set_pixel(
      map_x(tweet.point),
      map_y(tweet.point),
      ChunkyPNG::Color.rgba(0, 0, 0, 255))
  rescue ChunkyPNG::OutOfBounds
    puts "skipping pixel, out of bounds"
  end

  def map_x(point)
    offset = point.x - Tweet::NYC_BOTTOM_LEFT.x
    normalized_distance = (offset.to_f / @mercator_width)
    (normalized_distance * @width).to_i
  end

  def map_y(point)
    offset = point.y - Tweet::NYC_BOTTOM_LEFT.y

    # Intentionally use width again to force same scale
    normalized_distance = (offset.to_f / @mercator_width)
    mapped = (normalized_distance * @width).to_i

    # ChunkyPNG has row 0 at the top, not bottom of image. Flip
    @width - mapped
  end
end
