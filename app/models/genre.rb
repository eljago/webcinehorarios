# == Schema Information
#
# Table name: genres
#
#  id   :integer          not null, primary key
#  name :string(255)
#  slug :string(255)
#
# Indexes
#
#  index_genres_on_slug  (slug) UNIQUE
#

class Genre < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  attr_accessible :name
  has_and_belongs_to_many :shows
  
  validates :name, presence: :true, uniqueness: true
end
