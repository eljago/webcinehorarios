class ChangeNameToPrivilegesInUsers < ActiveRecord::Migration
  def up
    remove_column :users, :privilege
    add_column :users, :admin, :boolean
  end
  def down
    remove_column :users, :admin
    add_column :users, :privilege, :string
  end
end
