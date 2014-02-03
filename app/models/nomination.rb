class Nomination < ActiveRecord::Base
  attr_accessible :winner, :show_id, :award_specific_category_id, :nomination_person_roles_attributes
  
  belongs_to :award_specific_category
  belongs_to :show
  has_many :nomination_person_roles, dependent: :destroy
  has_many :people, through: :nomination_person_roles
  accepts_nested_attributes_for :nomination_person_roles, allow_destroy: true
end
