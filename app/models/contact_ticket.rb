class ContactTicket < ActiveRecord::Base
  attr_accessible :content, :from, :name, :subject
  
  validates :content, presence: true
  validates :name, :subject, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :from, presence: true, format: { with: VALID_EMAIL_REGEX }
end
