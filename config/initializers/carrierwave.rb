require 'carrierwave/processing/mime_types'
CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = true
end