class RemoveImageFromCountry < ActiveRecord::Migration
  def up
    remove_column :countries, :image
  end

  def down
    add_column :countries, :image, :string
  end
end
