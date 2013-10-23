module ApplicationHelper
  def controller_and_action
    controller_name = params[:controller].gsub('/', ' ')
    "#{controller_name} #{params[:action]}"
  end

  def last_snapshot_image(area)
    Snapshot.public_send(area).ascending.last.url
  end

  def analytics(hashtag_analytics, number_of_entries = 3)
    return unless hashtag_analytics
    rval = []
    hashtag_analytics.entries.first(number_of_entries).each do |entry|
      link = link_to("##{entry.term}", "https://twitter.com/search?src=typd&q=%23#{entry.term}")
      rval << content_tag(:li, "#{link}: #{entry.count}".html_safe)
    end

    content_tag(:ol, rval.join.html_safe)
  end

  def analytics_hour(hours)
    hours.each do |key, value|
      return value.created_at.strftime("%I%p") if value
    end
    nil
  end
end
