class ParsedShow < ActiveRecord::Base
  attr_accessible :name, :show_id
  
  belongs_to :show
end
