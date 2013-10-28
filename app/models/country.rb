class Country < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  attr_accessible :name
  
  has_many :cities, :dependent => :destroy

  validates :name, :presence => :true
end
