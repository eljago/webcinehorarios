namespace :clean_cineplanet do
  desc "Clean Cineplanet Pages Cache"
  task cache: :environment do
    dir_path = Rails.root.join(*%w( tmp cache functions ))
    FileUtils.rm_rf(Dir.glob(dir_path))
  end
end