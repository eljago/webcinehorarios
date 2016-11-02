object @show

attributes :id, :name, :duration, :name_original, :information, :rating, :year, :metacritic_url, :metacritic_score, :imdb_code, :imdb_score, :rotten_tomatoes_url, :rotten_tomatoes_score
node :image_url do |s|
	s.image_url
end
child :images do
	attributes :image_url
end
child @show.videos.where(video_type: 0) do
	attributes :name, :code, :image_url, :video_type
end
child :show_person_roles => :people do
	attributes :actor, :director, :character
	glue :person do
	  attributes :name, :image_url, :imdb_code
	end
end
node :debut do |s|
	s.debut.blank? ? nil : I18n.l(s.debut, format: :normal).capitalize
end
node :genres do |s|
	s.genres.order('genres.name ASC').select(:name).map do |genre|
		genre.name
	end.join(', ')
end
node :has_functions do |show|
	!show.functions.where('functions.date = ?',Date.current).count.zero?
end