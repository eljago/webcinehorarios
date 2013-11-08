collection @favorite_theaters
cache ['v2', @show.id, Digest::MD5.hexdigest(@favorite_theaters.map(&:id).join(','))], expires_in: 1.hour
attributes :id, :name, :cinema_id
child :functions do
	child :function_types do
		attributes :name
	end
	glue @show do
		attributes :id, :name, :image_url
		glue :portrait_image do
			attributes :image_url => :portrait_image
		end
	end
	child :showtimes do
		attributes :time
	end
end