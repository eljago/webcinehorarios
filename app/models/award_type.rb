# == Schema Information
#
# Table name: award_types
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class AwardType < ActiveRecord::Base
  attr_accessible :name
  
  has_many :awards
end
