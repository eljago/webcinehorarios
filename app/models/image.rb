# == Schema Information
#
# Table name: images
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  image            :string(255)
#  imageable_id     :integer
#  imageable_type   :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  image_tmp        :string(255)
#  width            :integer
#  height           :integer
#  show_portrait_id :integer
#

class Image < ActiveRecord::Base
  attr_accessible :name, :image, :remote_image_url, :width, :height, :show_portrait_id
  
  belongs_to :imageable, polymorphic: true
  
  mount_uploader :image, ShowImagesUploader
  #store_in_background :image
end
