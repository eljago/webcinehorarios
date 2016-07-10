# == Schema Information
#
# Table name: nominations
#
#  id                         :integer          not null, primary key
#  winner                     :boolean
#  award_specific_category_id :integer
#  show_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_nominations_on_award_specific_category_id_and_show_id  (award_specific_category_id,show_id)
#

class Nomination < ApplicationRecord

  belongs_to :award_specific_category
  belongs_to :show
  has_many :nomination_person_roles, dependent: :destroy
  has_many :people, through: :nomination_person_roles
  accepts_nested_attributes_for :nomination_person_roles, allow_destroy: true
  
end
