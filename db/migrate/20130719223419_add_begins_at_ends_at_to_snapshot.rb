class AddBeginsAtEndsAtToSnapshot < ActiveRecord::Migration
  def change
    add_column :snapshots, :begins_at, :datetime
    add_column :snapshots, :ends_at, :datetime
  end
end
