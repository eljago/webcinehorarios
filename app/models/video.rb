class Video < ApplicationRecord

  validates :name, presence: true

  VIDEO_TYPES = [ :youtube, :vimeo ]
  enum video_type: VIDEO_TYPES

  belongs_to :videoable, polymorphic: true
  belongs_to :show, foreign_key: :videoable_id

  validates :code, :video_type, :name, presence: true

  mount_uploader :image, VideoCover

  def self.cached_api_videos page = 1
    videos = select(:id, :created_at, :updated_at, :outstanding).joins(:show)
    	.where('shows.active = ? AND videos.outstanding = ?', true, true)
    	.order('videos.created_at DESC')
    	.paginate(page: page, per_page: 15).uniq

    videos_cache_keys = videos.map(&:cache_key).join(',')
    cache_key = Digest::MD5.hexdigest(videos_cache_keys)

    Rails.cache.fetch([name, 'videos', cache_key, page]) do
      videos_ids = videos.map(&:id)
    	where(id: videos_ids).includes(:show)
	    	.references(:show).order('videos.created_at DESC').uniq.to_a
    end
  end
end
