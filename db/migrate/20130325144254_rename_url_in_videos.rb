class RenameUrlInVideos < ActiveRecord::Migration
  def change
    rename_column :videos, :url, :code
  end
end
