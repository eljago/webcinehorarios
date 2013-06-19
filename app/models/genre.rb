class Genre < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :shows
  
  validates :name, presence: :true, uniqueness: true
end
