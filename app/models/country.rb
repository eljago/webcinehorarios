class Country < ActiveRecord::Base
  attr_accessible :name
  
  has_many :cities, :dependent => :destroy

  validates :name, :presence => :true
end
