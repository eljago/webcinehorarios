class ParseDetectorType < ActiveRecord::Base
  attr_accessible :cinema_id, :function_type_id, :name
  
  belongs_to :cinema
  belongs_to :function_type
end
