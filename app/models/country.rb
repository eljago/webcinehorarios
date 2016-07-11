class Country < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  has_many :cities, :dependent => :destroy
  has_many :theaters, through: :cities

  validates :name, :presence => :true
  
end
