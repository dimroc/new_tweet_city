class ImageService::Manhattan < ImageService
  def initialize
    @topright = Tweet::MANHATTAN_TOP_RIGHT
    @bottomleft = Tweet::MANHATTAN_BOTTOM_LEFT
    super
  end

  def generate
    Tweet.where(created_at: (@earliest..@latest)).within_manhattan.find_each do |tweet|
      set_pixel tweet
    end
  end
end
