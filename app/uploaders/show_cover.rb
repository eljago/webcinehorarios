# encoding: utf-8

class ShowCover < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  include CarrierWave::MiniMagick
  
  process :set_content_type
  storage :file
  # storage :fog
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/covers/#{model.class.to_s.underscore}/#{model.id}"
  end
  
  def filename
    @name ||= "#{secure_filename}.png" if original_filename
  end
  
  def default_url
    ActionController::Base.helpers.asset_path("uploads/default_images/" + [version_name, "MissingPicture.jpg"].compact.join('_'))
  end

  process :resize_to_limit => [1136,640], if: :is_landscape?
  process :resize_to_limit => [640,1136], if: :is_not_landscape?
  process convert: 'png'
  process :optimize
  
  version :small do
  process :resize_to_limit => [568,320], if: :is_landscape?
  process :resize_to_limit => [320,568], if: :is_not_landscape?
    process convert: 'png'
    process :optimize
  end
  version :smaller do
  process :resize_to_limit => [284,160], if: :is_landscape?
  process :resize_to_limit => [160,284], if: :is_not_landscape?
    process convert: 'png'
    process :optimize
  end
  version :smallest do
  process :resize_to_limit => [142,80], if: :is_landscape?
  process :resize_to_limit => [80,142], if: :is_not_landscape?
    process convert: 'png'
    process :optimize
  end
  
  private
  
  def optimize
    manipulate! do |img|
      img.format 'png'
      img.strip
      img.combine_options do |c|
        c.quality "90"
        c.depth "8"
        c.interlace "plane"
      end
      img
    end
  end
  
  def is_landscape? picture
    image = MiniMagick::Image.open(@file.file)
    image[:width] > image[:height]
  end
  def is_not_landscape? picture
    image = MiniMagick::Image.open(@file.file)
    image[:width] <= image[:height]
  end
  

  def secure_filename
    ivar = "@#{mounted_as}_a310d61f534ae85c02ei699fac4c4a5998f89517dd75ee24aar"
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, SecureRandom.hex(4))
  end
end