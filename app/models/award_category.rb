# == Schema Information
#
# Table name: award_categories
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class AwardCategory < ActiveRecord::Base
  # attr_accessible :name

  has_many :award_specific_nominations
  has_many :awards, through: :award_specific_nominations
end
