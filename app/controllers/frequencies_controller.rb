class FrequenciesController < ApplicationController
  def show
    @frequency = if params[:q]
                   Frequency.new(params[:id], params[:q])
                 else
                   Frequency.default
                 end
  end
end
