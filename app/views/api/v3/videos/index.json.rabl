collection @videos => :videos

attributes :id, :name, :code, :image_url, :video_type
child :show do
	attributes :id, :name
  
  node :image_url do |s|
    if s.images.where(poster: true).length > 0
      s.images.where(poster: true).first.image_url
    else
      "/uploads/default_images/default.png"
    end
  end
	
	glue :portrait_image do
		attributes :image_url => :portrait_image
	end
end