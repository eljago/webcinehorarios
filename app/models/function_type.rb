class FunctionType < ActiveRecord::Base
  attr_accessible :name
  
  has_and_belongs_to_many :functions
  has_many :parse_detector_types
  
  validates :name, presence: :true, uniqueness: true
  
end
