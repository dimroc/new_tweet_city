class FrequenciesController < ApplicationController
  def show
    raise ActiveRecord::RecordNotFound unless Borough.has? params[:id]
    query = params[:q].presence || "knicks"
    borough = params[:id].presence

    @frequency = Frequency.new(borough, query)
    @neighborhoods = Neighborhood.where(borough: borough.titleize)
  end
end
