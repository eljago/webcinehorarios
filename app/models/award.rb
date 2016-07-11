class Award < ApplicationRecord
  
  has_many :award_specific_categories, dependent: :destroy
  has_many :award_categories, through: :award_specific_nominations
  accepts_nested_attributes_for :award_specific_categories, allow_destroy: true
  belongs_to :award_type
  
  validates :name, :presence => :true

  mount_uploader :image, AwardCover
  
  def categories
    award_categories
  end
end
