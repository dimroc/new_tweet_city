class ImageService::Manhattan < ImageService
  def initialize(options={})
    @topright = Area.manhattan_top_right
    @bottomleft = Area.manhattan_bottom_left
    super(options)
  end

  def generate
    Tweet.where(created_at: (@earliest..@latest)).within_manhattan.find_each do |tweet|
      set_pixel tweet
    end
  end
end
