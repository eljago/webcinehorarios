# == Schema Information
#
# Table name: cinemas
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image       :string(255)
#  information :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string(255)
#  image_tmp   :string(255)
#
# Indexes
#
#  index_cinemas_on_slug  (slug) UNIQUE
#

class Cinema < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  # attr_accessible :image, :information, :name, :remote_image_url, :theater_ids
  
  has_many :theaters
  has_many :parse_detector_types
  has_and_belongs_to_many :function_types

  validates :name, :presence => :true

  mount_uploader :image, CinemaCover
  store_in_background :image
end
