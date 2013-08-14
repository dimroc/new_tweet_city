class ImageService::Nyc < ImageService
  def initialize(options={})
    @topright = Area.nyc_top_right
    @bottomleft = Area.nyc_bottom_left
    super(options)
  end

  def generate
    Tweet.where(created_at: (@earliest..@latest)).within_nyc.find_each do |tweet|
      set_pixel tweet
    end
  end
end
