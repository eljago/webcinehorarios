class Theater < ActiveRecord::Base
  attr_accessible :cinema_id, :city_id, :address, :information, :latitude, :longitude, :name, :web_label, :function_type_ids
  
  belongs_to :city
  belongs_to :cinema
  has_many :functions, :dependent => :destroy
  
  validates :name, :presence => :true
  
  accepts_nested_attributes_for :functions
end
