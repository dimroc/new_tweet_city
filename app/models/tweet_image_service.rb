class TweetImageService
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)

    @mercator_width = Tweet::MANHATTAN_TOP_RIGHT.x - Tweet::MANHATTAN_BOTTOM_LEFT.x
    @mercator_height = Tweet::MANHATTAN_TOP_RIGHT.y - Tweet::MANHATTAN_BOTTOM_LEFT.y

    @earliest = Tweet.order(:created_at).first.created_at
    @latest = Tweet.order("created_at DESC").first.created_at
  end

  def save(filename)
    Tweet.within_manhattan.find_each do |tweet|
      set_pixel tweet
    end

    @png.save filename
    FileUtils.cp filename, "tmp/latest.png"
  end

  private

  def set_pixel(tweet)
    pixel_coordinates = [
      map_x(tweet.point),
      map_y(tweet.point)]

    color = ChunkyPNG::Color.rgba(
      color_frequency(pixel_coordinates),
      0,
      255,
      255)

    @png[pixel_coordinates[0], pixel_coordinates[1]] = color

  rescue ChunkyPNG::OutOfBounds => e
    puts e.message
  end

  def map_x(point)
    offset = point.x - Tweet::MANHATTAN_BOTTOM_LEFT.x
    normalized_distance = (offset.to_f / @mercator_height)
    (normalized_distance * @height).to_i
  end

  def map_y(point)
    offset = point.y - Tweet::MANHATTAN_BOTTOM_LEFT.y

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

  def color_frequency(pixel_coordinates)
    @frequency_buckets ||= {}
    key = "#{pixel_coordinates[0]},#{pixel_coordinates[1]}".to_sym
    if @frequency_buckets[key]
      @frequency_buckets[key] += 1
    else
      @frequency_buckets[key] = 1
    end

    ((@frequency_buckets[key].to_f / 15) * 255).to_i
  end
end
