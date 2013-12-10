class AddSidekiqImagesTmpColumn < ActiveRecord::Migration
  def change
    add_column :cinemas, :image_tmp, :string
    add_column :videos, :image_tmp, :string
  end
end
