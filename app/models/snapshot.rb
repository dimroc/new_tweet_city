class Snapshot < ActiveRecord::Base
  Area::NAMES.each do |area|
    scope area, -> { where(area: area) } # nyc, manhattan, etc
  end

  scope :ascending, -> { order("ends_at ASC") }

  def update_image!
    upload = SnapshotFactory.new(area).generate_image(begins_at, ends_at)
    safe_delete_url
    update_attributes!(url: upload.public_url)
  end

  private

  def safe_delete_url
    FogService.new.delete url.match(/snapshots.*/)[0]
  rescue => e
    Rails.logger.warn "Unable to delete snapshot id #{id} image: #{e.message}"
  end
end
