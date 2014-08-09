# == Schema Information
#
# Table name: programs
#
#  id         :integer          not null, primary key
#  time       :datetime
#  name       :string(255)
#  channel_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_programs_on_channel_id  (channel_id)
#

class Program < ActiveRecord::Base
  belongs_to :channel
  attr_accessible :name, :time
end
