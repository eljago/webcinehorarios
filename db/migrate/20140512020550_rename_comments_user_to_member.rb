class RenameCommentsUserToMember < ActiveRecord::Migration
  def up
    remove_index :comments, :user_id
    rename_column :comments, :user_id, :member_id
    add_index :comments, :member_id
  end

  def down
    remove_index :comments, :member_id
    rename_column :comments, :member_id, :user_id
    add_index :comments, :user_id
  end
end
