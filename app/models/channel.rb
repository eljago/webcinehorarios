# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  vtr        :integer
#  directv    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Channel < ActiveRecord::Base
  # attr_accessible :directv, :name, :vtr
  
  has_many :programs
end
