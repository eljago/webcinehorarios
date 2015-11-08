collection @functions => :functions

cache ['v4', @cache_date, Digest::MD5.hexdigest(@functions.map(&:id).join(','))], expires_in: 30.minutes

attributes :id, :date

child :show do
	attributes :id, :name, :image_url
	glue :portrait_image do
		attributes :image_url => :portrait_image
	end
end

node :showtimes do |f|
	f.showtimes.order('showtimes.time').select('showtimes.time').map do |showtime|
		l showtime.time, format: :normal_time
	end.join(", ")
end

node :function_types do |f|
	f.function_types.order('function_types.name').select('function_types.name').map do |function_type|
		function_type.name
	end.join(', ')
end