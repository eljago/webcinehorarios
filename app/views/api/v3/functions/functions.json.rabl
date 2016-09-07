collection @functions
glue :show do
	attributes :id, :name
	node :image_url do |s|
	  s.image_url
	end
	node :portrait_image do |s|
	  s.portrait_image
	end
end
node :showtimes do |f|
	f.showtimes.order('showtimes.time ASC').select(:time).map do |showtime|
		I18n.l showtime.time, format: :normal_time
	end.join(", ")
end
node :function_types do |f|
	f.function_types.order('function_types.name ASC').select(:name).map do |function_type|
		function_type.name
	end.join(', ')
end