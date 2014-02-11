object @show
cache ['v2', @show], expires_in: 1.hour
attributes :id, :name, :duration, :year, :image_url, :name_original, :information, :debut, :rating, :metacritic_url, :imdb_code, :rotten_tomatoes_url, :imdb_score, :metacritic_score, :rotten_tomatoes_score
child :images do
	attributes :image_url
end
child :videos do
	attributes :name, :code, :image_url
end
child :genres do
	attributes :name
end
child :show_person_roles => :people do
	attributes :actor, :director, :character
	glue :person do
	  attributes :name, :image_url
	end
end