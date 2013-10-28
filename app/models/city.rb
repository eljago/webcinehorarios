class City < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  attr_accessible :name, :theater_ids
  
  belongs_to :country
  has_many :theaters

  validates :name, :presence => :true
end
