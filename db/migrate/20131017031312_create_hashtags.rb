class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.integer :tweet_id
      t.string :term

      t.timestamps
    end

    add_index :hashtags, :tweet_id
    add_index :hashtags, :term
    add_index :hashtags, :created_at
  end
end
