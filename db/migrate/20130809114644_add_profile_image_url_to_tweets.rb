class AddProfileImageUrlToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :profile_image_url, :string
  end
end
