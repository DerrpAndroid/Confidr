class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :content
      t.references :user, index: true
      t.boolean :global
      t.string :title

      t.timestamps
    end
    add_index :notifications, [:user_id, :created_at]
  end
end
