# == Schema Information
#
# Table name: shows
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  image                 :string(255)
#  information           :text
#  duration              :integer
#  name_original         :string(255)
#  rating                :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  debut                 :date
#  year                  :integer
#  active                :boolean
#  image_tmp             :string(255)
#  facebook_id           :string(255)
#  metacritic_url        :string(255)
#  metacritic_score      :integer
#  imdb_code             :string(255)
#  imdb_score            :integer
#  rotten_tomatoes_url   :string(255)
#  rotten_tomatoes_score :integer
#  slug                  :string(255)
#
# Indexes
#
#  index_shows_on_slug  (slug) UNIQUE
#

class Show < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  # attr_accessible :show_person_roles_attributes, :genre_ids, :active, :year, :debut, :name, :image, :information, :duration, :name_original, :rating, :remote_image_url, :images_attributes, :videos_attributes, :metacritic_url, :metacritic_score, :imdb_code, :imdb_score, :rotten_tomatoes_url, :rotten_tomatoes_score
  
  has_many :images, as: :imageable, dependent: :destroy
  has_and_belongs_to_many :genres
  has_many :functions, dependent: :destroy
  has_many :videos, as: :videoable, dependent: :destroy
  has_many :show_person_roles, dependent: :destroy
  has_many :people, through: :show_person_roles
  has_many :comments, dependent: :destroy
  has_many :parsed_shows, dependent: :destroy
  has_one :portrait_image, class_name: 'Image', foreign_key: :show_portrait_id
  has_many :nominations
  has_many :award_specific_nominations, through: :nominations
  
  validates :name, presence: :true
  
  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :show_person_roles, allow_destroy: true

  mount_uploader :image, ShowCover
  store_in_background :image
  
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
  
  def actors
    people.includes('show_person_roles').where('show_person_roles.actor'=>true)
  end
  def writers
    people.includes('show_person_roles').where('show_person_roles.writer'=>true)
  end
  def directors
    people.includes('show_person_roles').where('show_person_roles.director'=>true)
  end
  def creators
    people.includes('show_person_roles').where('show_person_roles.creator'=>true)
  end
  def producers
    people.includes('show_person_roles').where('show_person_roles.producer'=>true)
  end
end
