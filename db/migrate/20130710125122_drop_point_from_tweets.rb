class DropPointFromTweets < ActiveRecord::Migration
  def change
    remove_column :tweets, :point
  end
end
