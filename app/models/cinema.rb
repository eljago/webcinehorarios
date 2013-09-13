class Cinema < ActiveRecord::Base
  attr_accessible :image, :information, :name, :remote_image_url, :theater_ids
  
  has_many :theaters
  has_many :parse_detector_types
  has_and_belongs_to_many :function_types

  validates :name, :presence => :true

  mount_uploader :image, CinemaCover
end
