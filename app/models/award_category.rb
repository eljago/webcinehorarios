class AwardCategory < ApplicationRecord

  has_many :award_specific_nominations
  has_many :awards, through: :award_specific_nominations
  
end
