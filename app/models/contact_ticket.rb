class ContactTicket < ApplicationRecord

  validates :name, presence: true
  validates :content, presence: true
  validates :name, :subject, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :from, presence: true, format: { with: VALID_EMAIL_REGEX }
  
end
