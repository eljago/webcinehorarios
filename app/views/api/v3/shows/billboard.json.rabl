collection @shows
cache ['v3', @shows], expires_in: 1.hour
attributes :id, :name, :image_url, :duration, :name_original, :rating
child :genres do
	attributes :name
end
glue :portrait_image do
	attributes :image_url => :portrait_image
end