# == Schema Information
#
# Table name: show_person_roles
#
#  id         :integer          not null, primary key
#  person_id  :integer
#  show_id    :integer
#  actor      :boolean
#  writer     :boolean
#  creator    :boolean
#  producer   :boolean
#  director   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  character  :string(255)
#  position   :integer
#

class ShowPersonRole < ActiveRecord::Base
  acts_as_list
  
  attr_accessible :actor, :writer, :creator, :producer, :director, :person_id, :show_id, :character
  
  belongs_to :show
  belongs_to :person
end
