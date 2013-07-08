class AddPointIndexToTweets < ActiveRecord::Migration
  def change
    add_index :tweets, :point, spatial: true
  end
end
