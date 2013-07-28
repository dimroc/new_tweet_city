class AddMediaUrlAndTypeToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :media_url, :string
    add_column :tweets, :media_type, :string
  end
end
