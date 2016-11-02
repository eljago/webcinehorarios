collection @videos => :videos

attributes :id, :name, :code, :image_url, :video_type

child :show do
	attributes :id, :name
    
  node :image_url do |s|
    s.image_url
  end
  node :portrait_image do |s|
    s.portrait_image
  end
end