collection @shows => :movies
cache ['v3', Digest::MD5.hexdigest(@shows.map(&:id).join(','))], expires_in: 1.hour
attributes :id, :name, :image_url, :duration, :name_original
glue :portrait_image do
	attributes :image_url => :portrait_image
end
node :genres do |s|
	s.genres.order('genres.name ASC').select(:name).all.map do |genre|
		genre.name
	end.join(', ')
end