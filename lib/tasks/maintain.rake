namespace :maintain do
  desc "Destroy old functions"
  task functions: :environment do
    Function.where('functions.date < ?', Date.current-2).destroy_all
  end
end