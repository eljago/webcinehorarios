class City < ActiveRecord::Base
  attr_accessible :name, :theater_ids
  belongs_to :country
  
  has_many :theaters

  validates :name, :presence => :true
end
