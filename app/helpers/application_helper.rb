module ApplicationHelper
  def controller_and_action
    controller_name = params[:controller].gsub('/', ' ')
    "#{controller_name} #{params[:action]}"
  end

  def last_snapshot_image(area)
    Snapshot.public_send(area).ascending.last.url
  end
end
