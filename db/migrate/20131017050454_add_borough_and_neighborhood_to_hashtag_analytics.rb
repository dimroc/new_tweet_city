class AddBoroughAndNeighborhoodToHashtagAnalytics < ActiveRecord::Migration
  def change
    add_column :hashtag_analytics, :neighborhood_id, :integer
    add_column :hashtag_analytics, :borough, :string
  end
end
