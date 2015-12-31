class RenameTrailerFromVideos < ActiveRecord::Migration
  def up
  	Video.all.each do |video|
  		video.name = video.name.gsub('Trailer', 'Tráiler')
  		video.save
  	end
  end
end
