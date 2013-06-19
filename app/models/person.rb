class Person < ActiveRecord::Base
  attr_accessible :birthdate, :birthplace, :deathdate, :height, :information, :name, :image, :remote_image_url
  
  has_many :show_person_roles, :dependent => :destroy
  has_many :shows, through: :show_person_roles
  
  validates :name, :presence => :true
  
  mount_uploader :image, PersonCover
  store_in_background :image
end
