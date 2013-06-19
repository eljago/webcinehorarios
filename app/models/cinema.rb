class Cinema < ActiveRecord::Base
  attr_accessible :image, :information, :name, :remote_image_url, :theater_ids
  
  has_many :theaters, :dependent => :destroy

  validates :name, :presence => :true

  mount_uploader :image, CinemaCover
end
