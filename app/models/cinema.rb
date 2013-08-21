class Cinema < ActiveRecord::Base
  attr_accessible :image, :information, :name, :remote_image_url, :theater_ids
  
  has_many :theaters, :dependent => :destroy
  has_many :parse_detector_types

  validates :name, :presence => :true

  mount_uploader :image, CinemaCover
end
