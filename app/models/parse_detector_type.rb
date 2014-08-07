# == Schema Information
#
# Table name: parse_detector_types
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  function_type_id :integer
#  cinema_id        :integer
#

class ParseDetectorType < ActiveRecord::Base
  attr_accessible :cinema_id, :function_type_id, :name
  
  belongs_to :cinema
  belongs_to :function_type
end
