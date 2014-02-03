class AwardSpecificCategory < ActiveRecord::Base
  attr_accessible :name, :award_category_id, :award_id, :nominations_attributes
  
  belongs_to :award
  belongs_to :award_category
  has_many :shows, through: :nominations
  has_many :nominations
  accepts_nested_attributes_for :nominations, allow_destroy: true
  
  def winner
    Show.find(winner_show)
  end
end
