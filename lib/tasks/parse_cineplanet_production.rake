namespace :parse do
  desc "Parse Cineplanet"
  task :cineplanet_prod => :environment do

    dir_path = Rails.root.join(*%w( tmp cache functions ))
    FileUtils.mkdir(dir_path) unless File.exists?(dir_path)
    file_path = File.join(dir_path, "cineplanet.json")

    if File.exists?(file_path)
      str = File.read(file_path)
      hash = JSON.parse(str)

      Cinema.find_by(name: "Cineplanet").theaters.each do |theater|
        theater.task_parsed_hash hash
      end

    else
      puts "file cineplanet.json doesn't exists"
    end

  end
end
