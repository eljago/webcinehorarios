# encoding: utf-8

class AwardCover < CoverUploader

  def default_url
    "/assets/MissingActor.png"
  end

  process :resize_to_fit => [200, 200]
  process :optimize
  version :small do
    process :resize_to_fit => [100, 100]
    process :optimize
  end
end