class BoroughsController < ApplicationController
  def show
    @borough = params[:id].titleize
    @neighborhoods = Neighborhood.where("borough ILIKE ?", @borough)
    @tweets = fetch_tweets
  end

  private

  def fetch_tweets
    tweets = Tweet.for_borough(@borough).descending
    tweets = tweets.has_media if params[:only_media]
    tweets.first(30)
  end
end
