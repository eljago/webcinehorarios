class Genre < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  has_and_belongs_to_many :shows
  
  validates :name, presence: :true, uniqueness: true
  
end
