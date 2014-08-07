# == Schema Information
#
# Table name: videos
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  code           :string(255)
#  videoable_id   :integer
#  videoable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  image          :string(255)
#  image_tmp      :string(255)
#  outstanding    :boolean
#

class Video < ActiveRecord::Base
  attr_accessible :name, :code, :image, :remote_image_url, :outstanding
    
  validates :name, presence: true
  
  belongs_to :videoable, polymorphic: true
  belongs_to :show, foreign_key: :videoable_id
  
  mount_uploader :image, VideoCover
  #store_in_background :image
end
