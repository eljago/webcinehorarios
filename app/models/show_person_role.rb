class ShowPersonRole < ActiveRecord::Base
  attr_accessible :actor, :writer, :creator, :producer, :director, :person_id, :show_id, :character
  
  belongs_to :show
  belongs_to :person
end
