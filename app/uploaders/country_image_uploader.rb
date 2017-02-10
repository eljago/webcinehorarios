# encoding: utf-8

class CountryImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  # storage :fog

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/covers/#{model.class.to_s.underscore}/#{model.id}"
  end

  def default_url
    ActionController::Base.helpers.asset_path("uploads/default_images/" + [version_name, "MissingPicture.jpg"].compact.join('_'))
  end

  def filename
    @name ||= "#{secure_filename}.jpg" if original_filename
  end

  process :resize_to_limit => [512,270]
  process convert: 'jpg'
  process :optimize
  version :small do
    process :resize_to_limit => [256,135]
    process convert: 'jpg'
    process :optimize
  end
  version :smaller do
    process :resize_to_limit => [128,68]
    process convert: 'jpg'
    process :optimize
  end

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
      img
    end
  end

  def secure_filename
    ivar = "@#{mounted_as}_a310d61f534ae85c02ei699fac4c4a5998f89517dd75ee24aar"
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, SecureRandom.hex(4))
  end
end
