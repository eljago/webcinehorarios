class NominationPersonRole < ApplicationRecord

  belongs_to :person
  belongs_to :nomination
  
end
