class NominationPersonRole < ActiveRecord::Base
  attr_accessible :person_id, :nomination_id
  
  belongs_to :person
  belongs_to :nomination
end
