# == Schema Information
#
# Table name: parse_detector_types
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  function_type_id :integer
#  cinema_id        :integer
#
# Indexes
#
#  index_parse_detector_types_on_cinema_id         (cinema_id)
#  index_parse_detector_types_on_function_type_id  (function_type_id)
#

class ParseDetectorType < ApplicationRecord

  belongs_to :cinema
  belongs_to :function_type
  
end
