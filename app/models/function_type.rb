class FunctionType < ActiveRecord::Base
  attr_accessible :name
  
  has_and_belongs_to_many :functions
  
  validates :name, presence: :true, uniqueness: true
  
  
  def self.find_id_by_name name
    function_type = where(name: name).all.first
    if function_type
      function_type.id
    else
      0
    end
  end
end
