collection @shows
cache @shows, expires_in: 1.hour
attributes :id, :name, :image, :duration, :name_original, :rating
child :genres do
	attributes :name
end