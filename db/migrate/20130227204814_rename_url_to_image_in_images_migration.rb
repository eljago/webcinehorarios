class RenameUrlToImageInImagesMigration < ActiveRecord::Migration
  def change
    rename_column :images, :url, :image
  end
end
