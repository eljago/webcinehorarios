collection @people
cache @people, expires_in: 1.hour
attributes :name, :image
child :show_person_roles do
	attributes :actor, :director, :character
end