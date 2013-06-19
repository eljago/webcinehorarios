class AddCarrierwaveTmpColumns < ActiveRecord::Migration
  def change
    add_column :shows, :image_tmp, :string
    add_column :images, :image_tmp, :string
    add_column :people, :image_tmp, :string
  end
end
