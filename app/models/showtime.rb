class Showtime < ApplicationRecord
  
  validates :time, presence: true
  validates :function, presence: true
  
  belongs_to :function
  
end
