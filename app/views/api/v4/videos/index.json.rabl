collection @videos => :videos
cache ['v4', @videos], expires_in: 30.minutes
attributes :id, :name, :code, :image_url, :video_type
child :show do
  attributes :id => :show_id
  attributes :name, :image_url
	
  node :portrait_image do |s|
    if s.images.where(backdrop: true).length > 0
      s.images.where(backdrop: true).first.image_url
    else
      "/uploads/default_images/default.png"
    end
  end
end