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
		attributes :id, :name, :image_url
		glue :portrait_image do
			attributes :image_url => :portrait_image
		end
	end
	node :showtimes do |f|
		f.showtimes.order('showtimes.time ASC').select(:time).map do |showtime|
			I18n.l showtime.time, format: :normal_time
		end.join(', ')
	end
end