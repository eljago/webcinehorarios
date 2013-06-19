class Country < ActiveRecord::Base
  attr_accessible :image, :name, :remote_image_url
  has_many :cities, :dependent => :destroy

  validates :name, :presence => :true

end
