
namespace :parse do
  desc "Parse Channels"
  task :channels => :environment do
    require 'nokogiri'
    require 'open-uri'
    channels = Channel.all

    channels.each do |channel|
      URL = "http://www.directv.cl/guia/ChannelDetail.aspx?id=#{channel.directv}"
      s = open(URL).read            # Separate these three lines to convert &nbsp;
      s.gsub!('&nbsp;', ' ') 
      page = Nokogiri::HTML(s)

      n = "00"
      while
        time_li = page.css("li#ctl09_rptProgramming_ctl#{n}_liTime")
        title_li = page.css("li#ctl09_rptProgramming_ctl#{n}_liTitle")
        break if time_li.text == ""
  
        puts "#{n}: #{time_li.text} #{title_li.text.gsub!(/\s+/, ' ')}"
        name = title_li.text.gsub!(/\s+/, ' ')
        hourminute = time_li.text.split(":")
        time = Time.current.change(hour: hourminute[0], minute: hourminute[1])
  
        channel.programs.new(name: name, time: time).save
  
        n = (n.to_i + 1).to_s
        if n.size == 1
          n = "0#{n}"
        end
      end
    end
  end
end