class CreateNeighborhoods < ActiveRecord::Migration
  def change
    create_table :neighborhoods do |t|
      t.string :name, null: false
      t.string :slug
      t.string :borough, null: false
      t.geometry :geometry, srid: 3785

      t.timestamps
    end

    add_index :neighborhoods, :slug, unique: true
  end
end
