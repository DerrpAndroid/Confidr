class AddColumnsToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :senti, :string
    add_column :microposts, :sleephours, :string
    add_column :microposts, :health, :string
    add_column :microposts, :meditate, :string
    add_column :microposts, :happiness, :string
  end
end
