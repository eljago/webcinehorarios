collection @shows => :movies

attributes :id, :name, :duration, :name_original
node :image_url do |s|
  if s.images.where(poster: true).length > 0
    s.images.where(poster: true).first.image_url
  else
    "/uploads/default_images/default.png"
  end
end
node :portrait_image do |s|
  if s.images.where(backdrop: true).length > 0
    s.images.where(backdrop: true).first.image_url
  else
    "/uploads/default_images/default.png"
  end
end
node :genres do |s|
	s.genres.order('genres.name ASC').select(:name).map do |genre|
		genre.name
	end.join(', ')
end