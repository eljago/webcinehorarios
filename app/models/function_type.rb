class FunctionType < ActiveRecord::Base
  attr_accessible :name
  
  has_and_belongs_to_many :functions
  
  validates :name, presence: :true, uniqueness: true
  
end
