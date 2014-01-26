# encoding: utf-8

class PersonCover < CoverUploader

  def default_url
    "/assets/" + [version_name, "MissingActor.png"].compact.join('_')
  end

  process :resize_to_fit => [1136,640], if: :is_landscape?
  process :resize_to_fit => [640,1136], if: :is_not_landscape?
  process :optimize
  version :small do
    process :resize_to_fit => [568,320], if: :is_landscape?
    process :resize_to_fit => [320,568], if: :is_not_landscape?
    process :optimize
  end
  version :smaller do
    process :resize_to_fit => [284,160], if: :is_landscape?
    process :resize_to_fit => [160,284], if: :is_not_landscape?
    process :optimize
  end
  version :smallest do
    process :resize_to_fit => [142,80], if: :is_landscape?
    process :resize_to_fit => [80,142], if: :is_not_landscape?
    process :optimize
  end
  version :smallestest do
    process :resize_to_fit => [71,40], if: :is_landscape?
    process :resize_to_fit => [40,71], if: :is_not_landscape?
    process :optimize
  end
  
  def is_landscape? picture
    image = MiniMagick::Image.open(picture.path)
    image[:width] > image[:height]
  end
  def is_not_landscape? picture
    image = MiniMagick::Image.open(picture.path)
    image[:width] <= image[:height]
  end
end