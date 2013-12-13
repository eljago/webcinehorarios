collection @favorite_theaters
cache ['v3', @show.id, Digest::MD5.hexdigest(@favorite_theaters.map(&:id).join(','))], expires_in: 1.hour
attributes :id, :name, :cinema_id
child :functions do
	child :function_types do
		attributes :name
	end
	glue @show do
		attributes :id, :name, :image_url
		glue :portrait_image do
			attributes :image_url => :portrait_image
		end
	end
	node :showtimes do |f|
		f.showtimes.order('showtimes.time ASC').select(:time).all.map do |showtime|
			showtime.time.utc
		end
	end
end