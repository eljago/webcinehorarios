# == Schema Information
#
# Table name: award_types
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class AwardType < ApplicationRecord

  has_many :awards
  
end
