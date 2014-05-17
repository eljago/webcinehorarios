class Theater < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  attr_accessible :cinema_id, :city_id, :address, :information, :latitude, :longitude, :name, :web_url, :function_type_ids, :active
  
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

  
  def override_functions new_functions, start_date
    current_functions = functions.where('functions.date >= ?', start_date)
    functions_to_destroy = []
    indexes_to_save = Array.new(new_functions.count, true)
    
    current_functions.each do |function|
      found_identical = false
      new_functions.each_with_index do |new_function, index|
        next unless indexes_to_save[index]
        if function.total_identical? new_function
          found_identical = true
          indexes_to_save[index] = false
           break
        end
      end
      functions_to_destroy << function unless found_identical
    end
    
    functions_to_destroy.each do |f|
      f.destroy
    end
    indexes_to_save.each_with_index do |should_save, index|
      new_functions[index].save if should_save
    end
  end
end
