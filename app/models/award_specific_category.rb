class AwardSpecificCategory < ApplicationRecord
	
  belongs_to :award
  belongs_to :award_category
  has_many :shows, through: :nominations
  has_many :nominations, dependent: :destroy
  accepts_nested_attributes_for :nominations, allow_destroy: true
  
  def winner
    Show.find(winner_show)
  end
end
