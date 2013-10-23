class HashtagsController < ApplicationController
  def index
    @date = params[:date].try(:to_date) || DateTime.now
    @hours = analytics_for('hour', @date)
    @days = analytics_for('day', @date)
    @weeks = analytics_for('week', @date)
  end

  private

  def analytics_for(period, date = DateTime.now)
    analytics = {}
    Borough.names.each do |borough|
      analytics[borough] = HashtagAnalytics.
        where(created_at: (date - 1.day)..date).
        borough(borough).
        period(period).
        last
    end

    analytics
  end
end
