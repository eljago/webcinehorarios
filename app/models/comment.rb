# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  author     :string(255)
#  content    :text
#  member_id  :integer
#  show_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  attr_accessible :author, :content, :member_id, :show
  
  belongs_to :member
  belongs_to :show
end
