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
# Indexes
#
#  index_parsed_shows_on_show_id  (show_id)
#

class ParsedShow < ApplicationRecord
	
  belongs_to :show
  has_many :functions

end
