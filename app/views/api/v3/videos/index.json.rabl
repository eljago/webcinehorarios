collection @videos => :videos

attributes :id, :name, :code, :image_url, :video_type
child :show do
	attributes :id, :name, :image_url
	
	glue :portrait_image do
		attributes :image_url => :portrait_image
	end
end