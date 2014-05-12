class Comment < ActiveRecord::Base
  attr_accessible :author, :content, :member_id, :show
  
  belongs_to :member
  belongs_to :show
end
