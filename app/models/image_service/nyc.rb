class ImageService::Nyc < ImageService
  def initialize(options={})
    @topright = Tweet::NYC_TOP_RIGHT
    @bottomleft = Tweet::NYC_BOTTOM_LEFT
    super(options)
  end

  def generate
    Tweet.where(created_at: (@earliest..@latest)).within_nyc.find_each do |tweet|
      set_pixel tweet
    end
  end
end
