class ChangeTextStringToTextOnTweets < ActiveRecord::Migration
  def up
    change_column :tweets, :text, :text
  end

  def down
    change_column :tweets, :text, :string
  end
end
