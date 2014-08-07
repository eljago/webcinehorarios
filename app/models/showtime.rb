# == Schema Information
#
# Table name: showtimes
#
#  id          :integer          not null, primary key
#  time        :datetime
#  function_id :integer
#

class Showtime < ActiveRecord::Base
  
  attr_accessible :time
  
  validates :time, presence: true
  
  belongs_to :function
  
  def self.attributes_to_ignore_when_comparing
    [:id, :created_at, :updated_at, :function_id]
  end
  
end
