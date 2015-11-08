collection @videos => :videos
cache ['v4', @videos], expires_in: 30.minutes
attributes :id, :name, :code, :image_url, :video_type
child :show do
  attributes :id => :show_id
  attributes :name, :image_url
	
	glue :portrait_image do
		attributes :image_url => :portrait_image
	end
end