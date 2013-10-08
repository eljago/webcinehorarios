# encoding: utf-8

class VideoCover < ImageUploader
	
  def store_dir
    "uploads/covers/#{model.class.to_s.underscore}/#{model.id}"
  end
  
  def filename
    @name ||= "#{secure_filename}.jpg" if original_filename
  end
  
	process convert: 'jpg'
  
  process :resize_to_fit => [640,640]
  process :optimize
  version :small do
    process :resize_to_fit => [320,320]
    process :optimize
  end
  version :smaller do
    process :resize_to_fit => [160,160]
    process :optimize
  end
end