class Comment < ActiveRecord::Base
  attr_accessible :author, :content, :user, :show
  
  belongs_to :user
  belongs_to :show
end
