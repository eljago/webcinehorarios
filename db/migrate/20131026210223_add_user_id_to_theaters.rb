class AddUserIdToTheaters < ActiveRecord::Migration
  def change
    add_column :theaters, :user_id, :integer
    add_index :theaters, :user_id
  end
end
