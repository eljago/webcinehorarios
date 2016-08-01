class Person < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  has_many :show_person_roles, :dependent => :destroy
  has_many :shows, through: :show_person_roles
  has_many :nomination_person_roles, dependent: :destroy
  has_many :nominations, through: :nomination_person_roles

  validates :name, :presence => true
  validates :imdb_code, uniqueness: { case_sensitive: true }, allow_blank: true

  mount_uploader :image, PersonCover

  include PgSearch
  pg_search_scope :search, against: [:name, :imdb_code],
    using: {tsearch: {dictionary: "spanish"}}

  def self.text_search(query)
    if query.present?
      search(query)
    else
      order('created_at desc')
    end
  end

  def slug_candidates
    [ :name, [:name, :imdb_code] ]
  end
end
