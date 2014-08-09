# == Schema Information
#
# Table name: award_specific_categories
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  winner_type       :string(255)
#  winner_show       :integer
#  award_id          :integer
#  award_category_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  award_s_categories  (award_id,award_category_id)
#

class AwardSpecificCategory < ActiveRecord::Base
  attr_accessible :name, :award_category_id, :award_id, :nominations_attributes, :winner_type
  
  belongs_to :award
  belongs_to :award_category
  has_many :shows, through: :nominations
  has_many :nominations, dependent: :destroy
  accepts_nested_attributes_for :nominations, allow_destroy: true
  
  def winner
    Show.find(winner_show)
  end
end
