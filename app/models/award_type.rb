class AwardType < ActiveRecord::Base
  attr_accessible :name
  
  has_many :awards
end
