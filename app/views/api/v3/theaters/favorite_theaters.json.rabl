collection @favorite_theaters
cache ['v3', @show.id, Digest::MD5.hexdigest(@favorite_theaters.map(&:id).join(','))], expires_in: 1.hour
attributes :id, :name, :cinema_id
child :functions do
	node :function_types do |f|
		f.function_types.order('function_types.name ASC').select(:name).all.map do |ft|
			ft.name
		end.join(', ')
	end
	glue @show do
		attributes :id, :name, :image_url
		glue :portrait_image do
			attributes :image_url => :portrait_image
		end
	end
	node :showtimes do |f|
		f.showtimes.order('showtimes.time ASC').select(:time).all.map do |showtime|
			l showtime.time, format: :normal_time
		end.join(', ')
	end
end