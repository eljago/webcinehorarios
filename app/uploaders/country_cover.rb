# encoding: utf-8

class CountryCover < CoverUploader

  def default_url
    ActionController::Base.helpers.asset_path("uploads/default_images/" + [version_name, "MissingPicture.png"].compact.join('_'))
  end

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
  version :smallest do
    process :resize_to_limit => [142,80], if: :is_landscape?
    process :resize_to_limit => [80,142], if: :is_not_landscape?
    process :optimize
  end
  version :smallestest do
    process :resize_to_limit => [71,40], if: :is_landscape?
    process :resize_to_limit => [40,71], if: :is_not_landscape?
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