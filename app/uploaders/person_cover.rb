# encoding: utf-8

class PersonCover < CoverUploader

  def default_url
    "/assets/MissingActor.png"
  end
  
  process :resize_to_fit => [1136,1136]
  process :optimize
  version :small do
    process :resize_to_fit => [568,568]
    process :optimize
  end
  version :smaller do
    process :resize_to_fit => [284,284]
    process :optimize
  end
  version :smallest do
    process :resize_to_fit => [142,142]
    process :optimize
  end
  version :smallestest do
    process :resize_to_fit => [71,71]
    process :optimize
  end
end