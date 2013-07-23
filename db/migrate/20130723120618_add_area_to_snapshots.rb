class AddAreaToSnapshots < ActiveRecord::Migration
  def up
    add_column :snapshots, :area, :string
    execute("UPDATE snapshots SET area = 'manhattan'")
  end

  def down
    remove_column :snapshots, :area
  end
end
