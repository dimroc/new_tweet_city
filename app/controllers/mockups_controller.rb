class MockupsController < ApplicationController
  def page
    render "mockups/#{params[:page]}"
  end
end

