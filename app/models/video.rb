class Video < ActiveRecord::Base
  attr_accessible :name, :code, :image, :remote_image_url
    
  validates :name, presence: true
  
  belongs_to :videoable, polymorphic: true
  
  mount_uploader :image, VideoCover
  store_in_background :image
end
