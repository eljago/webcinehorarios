class RenameWebLabelFromTheaters < ActiveRecord::Migration
  def change
    rename_column :theaters, :web_label, :web_url
  end
end
