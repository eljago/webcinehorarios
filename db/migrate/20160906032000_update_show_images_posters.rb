class UpdateShowImagesPosters < ActiveRecord::Migration[5.0]
  def up
    add_column :images, :poster, :bool
    Show.order(:id).each do |show|
      image = show.images.new
      image.remote_image_url = "http://localhost:3000#{show.image_url}"
      image.poster = true
      image.save
    end
    remove_column :shows, :image
    remove_column :shows, :image_tmp
  end

  def down
    add_column :shows, :image, :string
    add_column :shows, :image_tmp, :string
    Show.order(:id).each do |show|
      show.images.where(poster: true).each_with_index do |image, index|
        if index == 0
          show.remote_image_url = "http://localhost:3000#{image.image_url}"
          show.save
        end
        image.destroy
      end
    end
    remove_column :images, :poster, :bool
  end
end
