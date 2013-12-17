class User < ActiveRecord::Base
  has_secure_password
  extend FriendlyId
  friendly_id :name, use: :slugged
  attr_accessible :name, :email, :password, :password_confirmation, :admin, :theater_ids
  
  has_many :comments
  has_many :theaters
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true, :length => { :in => 4..20 }
  validates :password, presence: true, :length => { :in => 8..20 }
  validates :password_confirmation, presence: true, :length => { :in => 8..20 }
end
