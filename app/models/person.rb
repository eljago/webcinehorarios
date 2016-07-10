# == Schema Information
#
# Table name: people
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  image      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image_tmp  :string(255)
#  slug       :string(255)
#  imdb_code  :string(255)
#
# Indexes
#
#  index_people_on_slug  (slug) UNIQUE
#

class Person < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  has_many :show_person_roles, :dependent => :destroy
  has_many :shows, through: :show_person_roles
  has_many :nomination_person_roles, dependent: :destroy
  has_many :nominations, through: :nomination_person_roles
  
  validates :name, :presence => :true
  
  mount_uploader :image, PersonCover

  include PgSearch
  pg_search_scope :search, against: [:name],
    using: {tsearch: {dictionary: "spanish"}}
    
  def self.text_search(query)
    if query.present?
      search(query)
    else
      order('created_at desc')
    end
  end
end
