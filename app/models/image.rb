class Image < ApplicationRecord

  belongs_to :imageable, polymorphic: true

  mount_uploader :image, ShowImagesUploader
  mount_base64_uploader :image, ShowImagesUploader

end
