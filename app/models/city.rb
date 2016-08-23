class City < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  belongs_to :country
  has_many :theaters

  validates :name, :presence => :true
end
