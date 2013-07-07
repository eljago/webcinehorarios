object @show
cache @show, expires_in: 1.hour
attributes :id, :name, :image, :duration, :name_original, :information, :debut, :rating, :year, :facebook_id
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