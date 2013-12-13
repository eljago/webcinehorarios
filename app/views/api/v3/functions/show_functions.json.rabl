collection @functions
cache ['v3', @show_id, @theater_id, @functions], expires_in: 1.hour
attributes :date
child :function_types do
	attributes :name
end
glue :show do
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