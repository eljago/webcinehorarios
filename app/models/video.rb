# == Schema Information
#
# Table name: videos
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  code           :string(255)
#  videoable_id   :integer
#  videoable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  image          :string(255)
#  image_tmp      :string(255)
#  outstanding    :boolean
#  video_type     :integer          default(0)
#
# Indexes
#
#  index_videos_on_videoable_id_and_videoable_type  (videoable_id,videoable_type)
#

class Video < ActiveRecord::Base
  # attr_accessible :name, :code, :image, :remote_image_url, :outstanding
    
  validates :name, presence: true
  
  VIDEO_TYPES = [ :youtube, :vimeo ]
  enum video_type: VIDEO_TYPES
  
  belongs_to :videoable, polymorphic: true
  belongs_to :show, foreign_key: :videoable_id
  
  mount_uploader :image, VideoCover
  

  def self.cached_api_videos page = 1
    videos = select(:id, :created_at, :updated_at).joins(:show)
    	.where('shows.active = ?', true)
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
