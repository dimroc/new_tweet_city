class CreateHashtagAnalytics < ActiveRecord::Migration
  def change
    create_table :hashtag_analytics do |t|
      t.string :period

      t.timestamps
    end
  end
end
