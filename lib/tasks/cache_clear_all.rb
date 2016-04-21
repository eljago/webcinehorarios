namespace :cache do
  desc "Clears Rails cache"
  task :clear_all => :environment do
    Rails.cache.clear
  end
end