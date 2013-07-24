class Snapshot < ActiveRecord::Base
  scope :nyc, -> { where(area: :nyc) }
  scope :manhattan, -> { where(area: :manhattan) }
end
