class RemoveColumnsFromMicroposts < ActiveRecord::Migration
  def change
    remove_column :microposts, :senti, :string
    remove_column :microposts, :sleephours, :string
    remove_column :microposts, :health, :string
    remove_column :microposts, :meditate, :string
    remove_column :microposts, :happiness, :string
  end
end
