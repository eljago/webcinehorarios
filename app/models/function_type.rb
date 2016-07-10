# == Schema Information
#
# Table name: function_types
#
#  id    :integer          not null, primary key
#  name  :string(255)
#  color :string(255)
#

class FunctionType < ApplicationRecord
	
  has_and_belongs_to_many :functions
  has_and_belongs_to_many :cinemas
  has_many :parse_detector_types, :dependent => :destroy
  
  validates :name, presence: :true, uniqueness: true
  
end
