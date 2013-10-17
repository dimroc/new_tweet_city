class CreateHashtagAnalyticsEntries < ActiveRecord::Migration
  def change
    create_table :hashtag_analytics_entries do |t|
      t.integer :hashtag_analytics_id
      t.string :term
      t.integer :count
    end

    add_index :hashtag_analytics_entries, :hashtag_analytics_id
  end
end
