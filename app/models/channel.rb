class Channel < ActiveRecord::Base
  attr_accessible :directv, :name, :vtr
  
  has_many :programs
end
