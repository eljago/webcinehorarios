# encoding: utf-8

class PersonCover < CoverUploader

  def default_url
    "/assets/MissingPicture.jpg"
  end
  
  process :resize_to_fit => [640,960]
  process :optimize
  version :small do
    process :resize_to_fit => [320,480]
    process :optimize
  end
  version :smaller do
    process :resize_to_fit => [174,260]
    process :optimize
  end
  version :smallest do
    process :resize_to_fit => [87,130]
    process :optimize
  end
  version :smallestest do
    process :resize_to_fit => [44,65]
    process :optimize
  end
end