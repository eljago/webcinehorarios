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
# Indexes
#
#  index_comments_on_member_id  (member_id)
#  index_comments_on_show_id    (show_id)
#

class Comment < ApplicationRecord

  belongs_to :member
  belongs_to :show
  
end
