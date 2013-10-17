class AddBoroughAndNeighborhoodToHashtags < ActiveRecord::Migration
  def change
    add_column :hashtags, :neighborhood_id, :integer
    add_column :hashtags, :borough, :string

    add_index :hashtags, :neighborhood_id
  end
end
