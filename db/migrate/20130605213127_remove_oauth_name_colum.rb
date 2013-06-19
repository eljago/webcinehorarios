class RemoveOauthNameColum < ActiveRecord::Migration
  def change
    remove_column :users, :oauth_name
  end
end
