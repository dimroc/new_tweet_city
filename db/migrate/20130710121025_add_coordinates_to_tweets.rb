class AddCoordinatesToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :coordinates, :point, srid: 3785
    add_index :tweets, :coordinates, spatial: true
  end
end
