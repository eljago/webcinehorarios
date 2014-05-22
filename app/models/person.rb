class Person < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  attr_accessible :birthdate, :birthplace, :deathdate, :height, :information, :name, :image, :remote_image_url
  
  has_many :show_person_roles, :dependent => :destroy
  has_many :shows, through: :show_person_roles
  has_many :nomination_person_roles, dependent: :destroy
  has_many :nominations, through: :nomination_person_roles
  
  validates :name, :presence => :true
  
  mount_uploader :image, PersonCover
  # store_in_background :image

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
