# encoding: utf-8

class ShowCover < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  include CarrierWave::MiniMagick
  
  storage :file
  
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
    "/assets/MissingPicture.jpg"
  end

  process :resize_to_fit => [1136,1136]
  process convert: 'png'
  process :optimize
  
  version :small do
    process :resize_to_fit => [568,568]
    process convert: 'png'
    process :optimize
  end
  version :smaller do
    process :resize_to_fit => [284,284]
    process convert: 'png'
    process :optimize
  end
  version :smallest do
    process :resize_to_fit => [142,142]
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
  

  def secure_filename
    ivar = "@#{mounted_as}_a310d61f534ae85c02ei699fac4c4a5998f89517dd75ee24aar"
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, SecureRandom.hex(4))
  end
end