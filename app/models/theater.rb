class Theater < ActiveRecord::Base
  attr_accessible :cinema_id, :city_id, :address, :information, :latitude, :longitude, :name, :web_label, :function_type_ids, :active
  
  belongs_to :city
  belongs_to :cinema
  has_many :functions, :dependent => :destroy
  
  validates :name, :presence => :true
  
  accepts_nested_attributes_for :functions
  
  def self.find_id_by_name name
    theater = where(name: name).first
    if theater
      theater.id
    else
      0
    end
  end
end
