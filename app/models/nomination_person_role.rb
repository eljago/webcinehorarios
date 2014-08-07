# == Schema Information
#
# Table name: nomination_person_roles
#
#  id            :integer          not null, primary key
#  nomination_id :integer
#  person_id     :integer
#

class NominationPersonRole < ActiveRecord::Base
  attr_accessible :person_id, :nomination_id
  
  belongs_to :person
  belongs_to :nomination
end
