# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string(255)
#
# Indexes
#
#  index_countries_on_slug  (slug) UNIQUE
#

class Country < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  has_many :cities, :dependent => :destroy
  has_many :theaters, through: :cities

  validates :name, :presence => :true
  
end
