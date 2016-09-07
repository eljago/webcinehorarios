collection @favorite_theaters
cache ['v2', @show.id, Digest::MD5.hexdigest(@favorite_theaters.map(&:id).join(','))], expires_in: 1.hour
attributes :id, :name, :cinema_id
child :functions do
	child :function_types do
		attributes :name
	end
	glue @show do
		attributes :id, :name, :image_url
		node :portrait_image do |s|
		  if s.images.where(backdrop: true).length > 0
		    s.images.where(backdrop: true).first.image_url
		  else
		    "/uploads/default_images/default.png"
		  end
		end
	end
	node :showtimes do |f|
		f.showtimes.order('showtimes.time ASC').select(:time).map do |showtime|
			{time: showtime.time.to_s.gsub(/ -0300/,"Z").sub(' ',"T")}
		end
	end
end