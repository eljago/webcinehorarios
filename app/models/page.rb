class Page < ActiveRecord::Base
  attr_accessible :content, :permalink, :title, :images_attributes
  
  has_many :images, as: :imageable, :dependent => :destroy
  
  validates :title, presence: true
  validates :permalink, presence: true, uniqueness: true
  
  accepts_nested_attributes_for :images, allow_destroy: true
end
