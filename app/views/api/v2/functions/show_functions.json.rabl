collection @functions
cache ['v2', @show_id, @theater_id, @functions], expires_in: 1.hour
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
child :showtimes do
	attributes :time
end