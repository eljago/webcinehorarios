object @show
cache ['v3', @show], expires_in: 1.hour
attributes :id, :name, :image_url, :duration, :name_original, :information, :rating, :year, :metacritic_url, :metacritic_score, :imdb_code, :imdb_score, :rotten_tomatoes_url, :rotten_tomatoes_score
child :images do
	attributes :image_url
end
child :videos do
	attributes :name, :code, :image_url
end
child :show_person_roles => :people do
	attributes :actor, :director, :character
	glue :person do
	  attributes :name, :image_url
	end
end
node :debut do |s|
	s.debut.blank? ? nil : l(s.debut, format: :longi).capitalize
end
node :genres do |s|
	s.genres.order('genres.name ASC').select(:name).all.map do |genre|
		genre.name
	end.join(', ')
end
node :has_functions do |show|
	!show.functions.where('functions.date = ?',Date.current).count.zero?
end