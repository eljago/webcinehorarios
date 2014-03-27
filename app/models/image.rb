class Image < ActiveRecord::Base
  attr_accessible :name, :image, :remote_image_url, :width, :height, :show_portrait_id
  
  belongs_to :imageable, polymorphic: true
  
  mount_uploader :image, ShowImagesUploader
  #store_in_background :image
end
