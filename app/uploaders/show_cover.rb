# encoding: utf-8

class ShowCover < CoverUploader
	
  def default_url
    "/assets/showCover.png"
  end
  
  process :resize_to_fit => [640,960]
  process :optimize
  version :small do
    process :resize_to_fit => [320,480]
    process :optimize
  end
  version :smaller do
    process :resize_to_fit => [160,240]
    process :optimize
  end
  version :smallest do
    process :resize_to_fit => [80,120]
    process :optimize
  end
end