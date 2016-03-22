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
#  created_at :datetime
#  updated_at :datetime
#  character  :string(255)
#  position   :integer
#
# Indexes
#
#  index_show_person_roles_on_person_id_and_show_id  (person_id,show_id)
#

class ShowPersonRole < ActiveRecord::Base
  acts_as_list
  
  # attr_accessible :actor, :writer, :creator, :producer, :director, :person_id, :show_id, :character
  
  belongs_to :show
  belongs_to :person
end
