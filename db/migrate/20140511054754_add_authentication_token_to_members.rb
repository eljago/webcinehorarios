class AddAuthenticationTokenToMembers < ActiveRecord::Migration
  def change
    add_column :members, :authentication_token, :string
    add_index :members, :authentication_token
  end
end
