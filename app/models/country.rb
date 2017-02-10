class Country < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :cities, :dependent => :destroy
  has_many :theaters, through: :cities
  has_and_belongs_to_many :shows

  validates :name, :presence => :true

  mount_uploader :image, CountryImageUploader
  mount_base64_uploader :image, CountryImageUploader

end
