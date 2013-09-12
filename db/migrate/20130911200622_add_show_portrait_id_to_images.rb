class AddShowPortraitIdToImages < ActiveRecord::Migration
  def change
    add_column :images, :show_portrait_id, :integer
    add_index :images, :show_portrait_id
  end
end
