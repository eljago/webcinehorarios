collection @functions
cache ['v2', @functions], expires_in: 1.hour
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
		f.showtimes.select(:time).all.map do |showtime|
			{time: showtime.time.to_s.gsub(/ -0300/,"Z").sub(' ',"T")}
		end
	end