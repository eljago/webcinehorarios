# == Schema Information
#
# Table name: parsed_shows
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  show_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ParsedShow < ActiveRecord::Base
  attr_accessible :name, :show_id
  
  belongs_to :show
end
