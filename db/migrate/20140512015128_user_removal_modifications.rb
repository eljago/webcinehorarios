class UserRemovalModifications < ActiveRecord::Migration
  def up
    remove_index :theaters, :user_id
    remove_column :theaters, :user_id
  end

  def down
    add_column :theaters, :user_id, :integer
    add_index :theaters, :user_id
  end
end
