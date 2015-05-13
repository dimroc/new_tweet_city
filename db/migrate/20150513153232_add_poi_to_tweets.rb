class AddPoiToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :poi, :boolean, default: false, null: false
  end
end
