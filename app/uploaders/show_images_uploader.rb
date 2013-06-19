# encoding: utf-8

class ShowImagesUploader < ImageUploader
  
  process convert: 'jpg'

  def filename
    @name ||= "#{secure_filename}.jpg" if original_filename
  end
  
  process :resize_to_fit => [960,960]
  process :optimize
  version :small do
    process :resize_to_fit => [480,480]
    process :optimize
  end
  version :smaller do
    process :resize_to_fit => [280,200]
    process :optimize
  end
end
