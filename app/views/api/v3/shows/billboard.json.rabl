collection @shows => :movies

attributes :id, :name, :duration, :name_original
node :image_url do |s|
  s.image_url
end
node :portrait_image do |s|
  s.portrait_image
end
node :genres do |s|
	s.genres.order('genres.name ASC').select(:name).map do |genre|
		genre.name
	end.join(', ')
end