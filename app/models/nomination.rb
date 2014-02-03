class Nomination < ActiveRecord::Base
  attr_accessible :winner, :show_id, :award_specific_nomination_id
  
  belongs_to :award_specific_nomination
  belongs_to :show
  has_and_belongs_to_many :people
end
