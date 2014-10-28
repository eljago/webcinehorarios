# encoding: utf-8

class CoverUploader < ImageUploader
  
  def store_dir
    "uploads/covers/#{model.class.to_s.underscore}/#{model.id}"
  end
  
  def default_url
    ActionController::Base.helpers.asset_path("fallback/" + [version_name, "MissingPicture.jpg"].compact.join('_'))
  end
  
  process convert: 'png'

  def filename
    @name ||= "#{secure_filename}.png" if original_filename
  end
end
