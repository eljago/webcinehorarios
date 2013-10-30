collection @shows
cache ['v2', @shows.map(&:id)], expires_in: 1.hour
attributes :id, :name, :image_url, :name_original, :debut
glue :portrait_image do
	attributes :image_url => :portrait_image
end