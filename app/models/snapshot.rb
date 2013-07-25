class Snapshot < ActiveRecord::Base
  Area::NAMES.each do |area|
    scope area, -> { where(area: area) } # nyc, manhattan, etc
  end

  scope :ascending, -> { order("ends_at ASC") }
end
