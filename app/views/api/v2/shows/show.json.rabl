object @show
cache ['v2', @show], expires_in: 1.hour
attributes :id, :name, :image_url, :name_original, :information, :debut, :rating, :metacritic_url, :imdb_code, :rotten_tomatoes_url
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
node :duration do |s|
	s.duration == 0 ? nil : s.duration
end
node :imdb_score do |s|
	s.imdb_score == 0 ? nil : s.imdb_score
end
node :metacritic_score do |s|
	s.metacritic_score == 0 ? nil : s.metacritic_score
end
node :rotten_tomatoes_score do |s|
	s.rotten_tomatoes_score == 0 ? nil : s.rotten_tomatoes_score
end
node :year do |s|
	s.year == 0 ? nil : s.year
end