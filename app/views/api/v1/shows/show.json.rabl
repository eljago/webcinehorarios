object @show
cache ['v1', @show], expires_in: 1.hour
attributes :id, :name, :image, :name_original, :information, :debut, :rating, :facebook_id
child :images do
	attributes :name, :image
end
child :videos do
	attributes :name, :code, :image
end
child :genres do
	attributes :name
end
child :show_person_roles => :people do
	attributes :actor, :director, :character
	glue :person do
	  attributes :name, :image
	end
end
node :duration do |s|
	s.duration == 0 ? nil : s.duration
end
node :year do |s|
	s.year == 0 ? nil : s.year
end