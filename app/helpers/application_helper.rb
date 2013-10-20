module ApplicationHelper
  def controller_and_action
    controller_name = params[:controller].gsub('/', ' ')
    "#{controller_name} #{params[:action]}"
  end

  def last_snapshot_image(area)
    Snapshot.public_send(area).ascending.last.url
  end

  def analytics(hashtag_analytics)
    rval = []
    hashtag_analytics.entries.first(3).each_with_index do |entry, index|
      rval << content_tag(:div, "#{index}) Term: #{entry.term} Count: #{entry.count}")
    end

    rval.join.html_safe
  end
end
