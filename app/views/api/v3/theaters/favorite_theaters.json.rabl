collection @favorite_theaters

attributes :id, :name, :cinema_id

node :date do
	@date
end

child :functions do
	node :function_types do |f|
		f.function_types.order('function_types.name ASC').select(:name).map do |ft|
			ft.name
		end.join(', ')
	end
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
		end.join(', ')
	end
end