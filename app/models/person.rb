class Person < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  has_many :images, as: :imageable, dependent: :destroy
  has_many :show_person_roles, :dependent => :destroy
  has_many :shows, through: :show_person_roles
  has_many :nomination_person_roles, dependent: :destroy
  has_many :nominations, through: :nomination_person_roles

  accepts_nested_attributes_for :images, allow_destroy: true
  validates_associated :images

  validates :name, :presence => true
  validates :imdb_code, format: { with: /\Anm\d{7}\z/,
    message: "%{value} no es un formato válido" }, allow_blank: true
  validates :imdb_code, uniqueness: { case_sensitive: true }, allow_blank: true

  mount_uploader :image, PersonCover
  mount_base64_uploader :image, PersonCover

  include PgSearch
  pg_search_scope :search, against: [:name, :imdb_code],
    using: {tsearch: {dictionary: "spanish", :prefix => true}}

  def self.text_search(query)
    if query.present?
      search(query)
    else
      order('people.created_at desc')
    end
  end

  def image_url version = nil
    if images.where(poster: true).size > 0
      if version
        return images.where(poster: true).first.image.send(version).url
      end
      images.where(poster: true).first.image_url
    else
      '/uploads/default_images/default.png'
    end
  end

  def slug_candidates
    [ :name, [:name, :imdb_code] ]
  end
end
