class AddGeographicCoordinatesToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :geographic_coordinates, :point, geographic: true
  end
end
