class BoroughsController < ApplicationController
  def show
    @borough = params[:id].titleize
    @neighborhoods = Neighborhood.where("borough ILIKE ?", @borough)
    @tweets = Tweet.for_borough(@borough).descending.first(20)
  end
end
