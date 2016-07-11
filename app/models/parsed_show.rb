class ParsedShow < ApplicationRecord
	
  belongs_to :show
  has_many :functions

end
