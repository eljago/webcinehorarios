# encoding: utf-8

class CinemaCover < CoverUploader
  
  def default_url
    ActionController::Base.helpers.asset_path("uploads/default_images/" + [version_name, "MissingPicture.jpgpng"].compact.join('_'))
  end
  
  process :resize_to_fit => [200,200]
  process :optimize
  version :small do
    process :resize_to_fit => [100,100]
    process :optimize
  end
end