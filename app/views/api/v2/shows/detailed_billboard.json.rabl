collection @shows
cache @shows, expires_in: 1.hour
attributes :id, :name, :image, :duration, :name_original, :information, :debut, :rating, :year
child :images do
	attributes :name, :image
end
child :videos do
	attributes :name, :code, :image
end
child :genres do
	attributes :name
end
