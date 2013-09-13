# encoding: utf-8

class CinemaCover < CoverUploader
  
  def default_url
    "/assets/personCover.png"
  end
  
  process :resize_to_fit => [160,160]
  process :optimize
  version :small do
    process :resize_to_fit => [80,80]
    process :optimize
  end
end