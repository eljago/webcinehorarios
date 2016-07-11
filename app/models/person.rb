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
