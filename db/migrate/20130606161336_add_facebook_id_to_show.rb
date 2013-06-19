class AddFacebookIdToShow < ActiveRecord::Migration
  def change
    add_column :shows, :facebook_id, :string
  end
end
