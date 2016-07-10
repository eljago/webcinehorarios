# == Schema Information
#
# Table name: contact_tickets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  from       :string(255)
#  subject    :string(255)
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContactTicket < ApplicationRecord

  validates :name, presence: true
  validates :content, presence: true
  validates :name, :subject, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :from, presence: true, format: { with: VALID_EMAIL_REGEX }
  
end
