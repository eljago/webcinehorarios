class Show < ActiveRecord::Base
  attr_accessible :show_person_roles_attributes, :genre_ids, :active, :year, :debut, :name, :image, :information, 
  :duration, :name_original, :rating, :remote_image_url, :images_attributes, :videos_attributes, :facebook_id
  
  has_many :images, as: :imageable, dependent: :destroy
  has_and_belongs_to_many :genres
  has_many :functions, dependent: :destroy
  has_many :videos, as: :videoable, dependent: :destroy
  has_many :show_person_roles, dependent: :destroy
  has_many :people, through: :show_person_roles
  has_many :comments, dependent: :destroy
  has_many :parsed_shows, dependent: :destroy
  
  validates :name, presence: :true
  
  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :show_person_roles, allow_destroy: true

  mount_uploader :image, ShowCover
  store_in_background :image
  
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
