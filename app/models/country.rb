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

class Country < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  attr_accessible :name
  
  has_many :cities, :dependent => :destroy

  validates :name, :presence => :true
end
