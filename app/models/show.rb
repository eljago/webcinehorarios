class Show < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

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
  has_many :show_debuts, dependent: :destroy

  validates :name, presence: :true
  validates_associated :images
  validates_associated :videos
  validates_associated :show_person_roles
  validates_associated :people

  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :show_person_roles, allow_destroy: true

  after_commit :flush_cache

  mount_uploader :image, ShowCover
  mount_base64_uploader :image, ShowCover

  include PgSearch
  pg_search_scope :search, against: [:name, :name_original, :imdb_code],
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


  ### API ###

  # THEATERS cinema_id
  def self.api_theater_shows theater_id, date_range
    includes(functions: [:function_types, :showtimes]).includes(:genres)
      .where(functions: {theater_id: theater_id, date: date_range})
      .order('shows.debut DESC, genres.name, function_types.name, showtimes.time')
  end

  def self.cached_api_theater_shows theater_id, date_start
    date_start = Date.parse(date_start)
    date_range = date_start..date_start+6
    times_joined = Showtime.select(:id, :time).joins(:function).where(functions: {theater_id: theater_id, date: date_range}).order(:time).uniq
    .map do |showtime|
      showtime.time.strftime "%H%M"
    end.join(',')

    funciton_types_joined = Function.select(:id).includes(:function_types).where({theater_id: theater_id, date: date_range}).order(:id).uniq.map do |function|
      function.function_types.map(&:name).join(',')
    end.join(',')

    showtimes_cache_key = Digest::MD5.hexdigest(times_joined)
    function_types_cache_key = Digest::MD5.hexdigest(funciton_types_joined)

    Rails.cache.fetch([name, theater_id, date_start, showtimes_cache_key, function_types_cache_key], expires_in: 30.minutes) do
      api_theater_shows(theater_id, date_range).to_a
    end
  end

  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end

  # BILLBOARD

  def self.cached_api_billboard
    current_day = Date.current
    date = current_day + ((3-current_day.wday) % 7)
    shows = joins(:functions).select(:id, :updated_at)
      .where('shows.active = ? AND shows.debut <= ? AND functions.date = ?', true, date, current_day)
      .order(:id).uniq

    shows_cache_keys = shows.map(&:cache_key).join(',')
    cache_key = Digest::MD5.hexdigest(shows_cache_keys)

    Rails.cache.fetch([name, 'billboard', cache_key], expires_in: 30.minutes) do
      shows_ids = shows.map(&:id)
      where(id: shows_ids).order('shows.debut DESC')
      .includes(:genres).order('genres.name').to_a
    end
  end

  # COMING SOON

  def self.cached_api_coming_soon
    shows = where('active = ? AND (debut > ? OR debut IS ?)', true, Date.current, nil)
      .select(:id, :updated_at, :debut)
      .order(:debut).uniq

    shows_cache_keys = shows.map(&:cache_key).join(',')
    cache_key = Digest::MD5.hexdigest(shows_cache_keys)

    Rails.cache.fetch([name, 'coming_soon', cache_key], expires_in: 30.minutes) do
      shows_ids = shows.map(&:id)
      where(id: shows_ids).order(:debut).includes(:genres).order('genres.name').to_a
    end
  end

  # SHOW
  def self.cached_api_show id
    Rails.cache.fetch([name, id]) do
      where(id: id).includes(:portrait_image, :genres, :images, :videos, :show_person_roles => :person)
      .where('videos.video_type = ?', 0)
      .order('genres.name, videos.created_at DESC, images.created_at DESC, show_person_roles.position').first
    end
  end
end
