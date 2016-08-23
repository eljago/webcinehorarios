class Cinema < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  has_many :theaters
  has_many :parse_detector_types
  has_and_belongs_to_many :function_types

  validates :name, :presence => :true

  mount_uploader :image, CinemaCover
end
