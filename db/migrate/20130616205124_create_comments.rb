class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :author
      t.text :content
      t.integer :user_id
      t.integer :show_id

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :show_id
  end
end
