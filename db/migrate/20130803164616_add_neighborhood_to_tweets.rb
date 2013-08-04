class AddNeighborhoodToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :neighborhood_id, :integer
    add_index :tweets, :neighborhood_id
  end
end
