class BoroughsController < ApplicationController
  def show
    @borough = params[:id].titleize
    @neighborhoods = Neighborhood.where("borough ILIKE ?", @borough)
  end
end
