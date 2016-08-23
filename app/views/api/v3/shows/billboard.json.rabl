collection @shows => :movies

attributes :id, :name, :image_url, :duration, :name_original
glue :portrait_image do
	attributes :image_url => :portrait_image
end
node :genres do |s|
	s.genres.order('genres.name ASC').select(:name).map do |genre|
		genre.name
	end.join(', ')
end