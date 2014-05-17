# encoding: utf-8

class VideoCover < ImageUploader
	
  def store_dir
    "uploads/covers/#{model.class.to_s.underscore}/#{model.id}"
  end
  
  def default_url
    "/assets/" + [version_name, "MissingPicture.jpg"].compact.join('_')
  end
  
  
  def filename
    @name ||= "#{secure_filename}.jpg" if original_filename
  end
  
	process convert: 'jpg'
  
  process :resize_to_limit => [1136,640], if: :is_landscape?
  process :resize_to_limit => [640,1136], if: :is_not_landscape?
  process :optimize
  version :small do
    process :resize_to_limit => [568,320], if: :is_landscape?
    process :resize_to_limit => [320,568], if: :is_not_landscape?
    process :optimize
  end
  version :smaller do
    process :resize_to_limit => [284,160], if: :is_landscape?
    process :resize_to_limit => [160,284], if: :is_not_landscape?
    process :optimize
  end
  
  private
  
  def is_landscape? picture
    image = MiniMagick::Image.open(@file.file)
    image[:width] > image[:height]
  end
  def is_not_landscape? picture
    image = MiniMagick::Image.open(@file.file)
    image[:width] <= image[:height]
  end
end