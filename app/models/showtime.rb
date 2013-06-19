class Showtime < ActiveRecord::Base
  
  attr_accessible :time
  
  validates :time, presence: true, uniqueness: true
  
  has_and_belongs_to_many :function
end
