class AddOutstandingToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :outstanding, :boolean
  end
end
