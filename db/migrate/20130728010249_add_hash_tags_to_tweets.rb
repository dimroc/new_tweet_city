class AddHashTagsToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :hashtags, :string
  end
end
