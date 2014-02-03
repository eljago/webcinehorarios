class Award < ActiveRecord::Base
  attr_accessible :name, :active, :date, :image, :award_specific_nominations_attributes
  
  has_many :award_specific_nominations, dependent: :destroy
  has_many :award_categories, through: :award_specific_nominations
  accepts_nested_attributes_for :award_specific_nominations, allow_destroy: true
  
  validates :name, :presence => :true

  mount_uploader :image, AwardCover
  store_in_background :image
  
  def categories
    award_categories
  end
end
