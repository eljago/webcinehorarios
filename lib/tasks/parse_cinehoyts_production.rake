
namespace :parse do
  desc "Parse Cine Hoyts Production"
  task :cinehoyts_prod => :environment do

    dir_path = Rails.root.join(*%w( tmp cache functions ))
    FileUtils.mkdir(dir_path) unless File.exists?(dir_path)
    file_path = File.join(dir_path, "cine_hoyts.json")

    if File.exists?(file_path)
      str = File.read(file_path)
      hash = JSON.parse(str)
      
      Cinema.find_by(name: "Cine Hoyts").theaters.each do |theater|
        theater.task_parsed_hash hash
      end
      Cinema.find_by(name: "Cinemundo").theaters.each do |theater|
        theater.task_parsed_hash hash
      end

    else
      puts "file cine_hoyts.json doesn't exists"
    end

  end
end
