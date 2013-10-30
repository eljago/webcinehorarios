# encoding: utf-8

class CinemaCover < CoverUploader
  
  def default_url
    "/assets/" + [version_name, "MissingPicture.jpg"].compact.join('_')
  end
  
  process :resize_to_fit => [200,200]
  process :optimize
  version :small do
    process :resize_to_fit => [100,100]
    process :optimize
  end
end