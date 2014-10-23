class AddSentiToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :senti, :string
  end
end
