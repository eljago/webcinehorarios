class AddBackdropToImages < ActiveRecord::Migration[5.0]
  def up
    add_column :images, :backdrop, :bool
    Image.where('images.show_portrait_id IS NOT NULL AND images.show_portrait_id > ?', 0).each do |image|
      image.backdrop = true
      image.save
    end
  end

  def down
    remove_column :images, :backdrop, :bool
  end
end
