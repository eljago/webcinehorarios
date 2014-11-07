collection @functions
glue :show do
	attributes :id, :name, :image_url
	glue :portrait_image do
		attributes :image_url => :portrait_image
	end
end
node :showtimes do |f|
	f.showtimes.order('showtimes.time ASC').select(:time).map do |showtime|
		l showtime.time, format: :normal_time
	end.join(", ")
end
node :function_types do |f|
	f.function_types.order('function_types.name ASC').select(:name).map do |function_type|
		function_type.name
	end.join(', ')
end