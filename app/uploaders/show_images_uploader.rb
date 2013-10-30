# encoding: utf-8

class ShowImagesUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  include CarrierWave::MimeTypes
  include CarrierWave::MiniMagick
  
  storage :file
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/images/#{model.class.to_s.underscore}/#{model.id}"
  end
  
  def default_url
    "/assets/" + [version_name, "MissingPicture.jpg"].compact.join('_')
  end

  def filename
    @name ||= "#{secure_filename}.jpg" if original_filename
  end
  
  process :resize_to_fit => [1136,1136]
  process convert: 'jpg'
  process :optimize
  version :small do
    process :resize_to_fit => [568,568]
    process convert: 'jpg'
    process :optimize
  end
  version :smaller do
    process :resize_to_fit => [284,284]
    process convert: 'jpg'
    process :optimize
  end
  
  process :set_content_type
  
  private
  
  def optimize
    manipulate! do |img|
      img.format 'jpg'
      img.strip
      img.combine_options do |c|
        c.quality "90"
        c.depth "8"
        c.interlace "plane"
      end
      if model
        model.width = img[:width]
        model.height = img[:height]
      end
      img
    end
  end

  def secure_filename
    ivar = "@#{mounted_as}_a310d61f534ae85c02ei699fac4c4a5998f89517dd75ee24aar"
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, SecureRandom.hex(4))
  end
end
