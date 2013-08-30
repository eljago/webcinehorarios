namespace :cache do
  desc "Carrierwave Clean Cached Files"
  task :carrierwave_clean => :environment do
    CarrierWave.clean_cached_files!
  end
end