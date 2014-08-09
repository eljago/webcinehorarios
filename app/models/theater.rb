# == Schema Information
#
# Table name: theaters
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image       :string(255)
#  address     :string(255)
#  information :text
#  cinema_id   :integer
#  city_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  web_url     :string(255)
#  active      :boolean
#  slug        :string(255)
#  latitude    :decimal(15, 10)
#  longitude   :decimal(15, 10)
#
# Indexes
#
#  index_theaters_on_city_id_and_cinema_id  (city_id,cinema_id)
#  index_theaters_on_slug                   (slug) UNIQUE
#

class Theater < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
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

  
  def override_functions new_functions, start_date, parse_days_count
    current_functions = functions.where('functions.date >= ? and functions.date < ?', start_date, start_date + parse_days_count.to_i)
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
