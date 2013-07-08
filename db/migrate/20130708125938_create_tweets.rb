class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.point :point, srid: 3857
      t.string :text

      t.timestamps
    end

    add_index :tweets, :created_at
  end
end
