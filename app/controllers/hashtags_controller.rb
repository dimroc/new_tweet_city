class HashtagsController < ApplicationController
  def index
    @hours = analytics_for('hour')
    @days = analytics_for('day')
    @weeks = analytics_for('week')
  end

  private

  def analytics_for(period)
    analytics = {}
    Borough.names.each do |borough|
      analytics[borough] = HashtagAnalytics.borough(borough).period(period).first
    end

    analytics
  end
end
