# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  image      :string(255)
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string(255)
#
# Indexes
#
#  index_cities_on_country_id  (country_id)
#  index_cities_on_slug        (slug) UNIQUE
#

class City < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  # attr_accessible :name, :theater_ids
  
  belongs_to :country
  has_many :theaters

  validates :name, :presence => :true
end
