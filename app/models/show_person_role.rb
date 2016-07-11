class ShowPersonRole < ApplicationRecord
  acts_as_list
  
  belongs_to :show
  belongs_to :person

end
