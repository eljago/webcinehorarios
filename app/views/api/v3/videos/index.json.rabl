collection @videos => :videos
cache ['v3', @videos], expires_in: 1.hour
attributes :id, :name, :code, :image_url
child :videoable do
	attributes :id, :name, :image_url
	
	glue :portrait_image do
		attributes :image_url => :portrait_image
	end
end