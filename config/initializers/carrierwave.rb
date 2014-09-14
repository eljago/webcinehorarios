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
    aws_access_key_id: Rails.application.secret.aws_access_key_id,
    aws_secret_access_key: Rails.application.secret.aws_secret_access_key
  }
  config.fog_directory = Rails.application.secret.fog_directory
  config.asset_host = "http://#{config.fog_directory}.s3.amazonaws.com"
end