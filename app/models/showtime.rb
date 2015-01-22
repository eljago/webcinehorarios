# == Schema Information
#
# Table name: showtimes
#
#  id          :integer          not null, primary key
#  time        :datetime
#  function_id :integer
#
# Indexes
#
#  index_showtimes_on_function_id  (function_id)
#

class Showtime < ActiveRecord::Base
  
  # attr_accessible :time
  
  validates :time, presence: true
  validates :function, presence: true
  
  belongs_to :function
  
end
