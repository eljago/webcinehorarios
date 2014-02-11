collection @shows
cache ['v1', @shows], expires_in: 1.hour
attributes :id, :name, :duration, :image, :name_original, :rating
child :genres do
	attributes :name
end