class UpdateShowImagesPosters < ActiveRecord::Migration[5.0]
  def up
    add_column :images, :poster, :bool
    remove_column :shows, :image
    remove_column :shows, :image_tmp
  end

  def down
    add_column :shows, :image, :string
    add_column :shows, :image_tmp, :string
    remove_column :images, :poster, :bool
  end
end
