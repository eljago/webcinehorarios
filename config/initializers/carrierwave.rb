require 'carrierwave/processing/mime_types'
# CarrierWave.configure do |config|
#   config.storage = :file
#   config.enable_processing = true
# end

CarrierWave.configure do |config|
  config.storage = :fog
  config.enable_processing = true

  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
  }
  config.fog_directory = ENV["FOG_DIRECTORY"]
  
end