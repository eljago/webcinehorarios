class Video < ActiveRecord::Base
  attr_accessible :name, :code, :image, :remote_image_url, :outstanding
    
  validates :name, presence: true
  
  belongs_to :videoable, polymorphic: true
  belongs_to :show, foreign_key: :videoable_id
  
  mount_uploader :image, VideoCover
  store_in_background :image
end
