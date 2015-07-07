require "#{Rails.root}/app/helpers/theater_parser_helper"
include TheaterParserHelper

namespace :parse do
  desc "Parse Cinemark"
  task :cineplanet => :environment do
    
    time_start = Time.current
    
    cinestar_theaters = Cinema.where(name: "Cineplanet").first.theaters
    cinestar_theaters.each do |theater|
      task_parse_theater theater
    end
    
    if Rails.env.production?
      time_end = Time.current
      duration = time_end - time_start
      min = (duration / 60).round
      sec = (duration % 60).round
    
      date = Date.current
      from = "noreply@cinehorarios.cl"
      subject = "PARSE CINEPLANET COMPLETE #{date.day}/#{date.month}/#{date.year}"
      content = "Operación duró #{min} minutos y #{sec} segundos."
      contact_ticket = ContactTicket.new(from: from, subject: subject, content: content)
      ContactMailer.parse_complete_mailer(contact_ticket).deliver
    end
    
  end
end