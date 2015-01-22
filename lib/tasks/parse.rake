require "#{Rails.root}/app/helpers/theater_parser_helper"
include TheaterParserHelper

namespace :parse_cinemas do
  desc "Parse Cinemark"
  task :cinemark => :environment do
    task_parse_cinemark
  end
end