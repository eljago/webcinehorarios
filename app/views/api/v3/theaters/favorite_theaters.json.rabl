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
		  if s.images.where(poster: true).length > 0
		    s.images.where(poster: true).first.image_url
		  else
		    "/uploads/default_images/default.png"
		  end
		end
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
			I18n.l showtime.time, format: :normal_time
		end.join(', ')
	end
end