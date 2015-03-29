class AddHappinessToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :health, :string
    add_column :microposts, :happiness, :string
    add_column :microposts, :meditate, :string
  end
end
