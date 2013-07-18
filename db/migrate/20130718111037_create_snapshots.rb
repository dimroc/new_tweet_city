class CreateSnapshots < ActiveRecord::Migration
  def change
    create_table :snapshots do |t|
      t.string :url
      t.integer :tweet_count

      t.timestamps
    end
  end
end
