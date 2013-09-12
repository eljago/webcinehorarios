collection @shows
cache ['v2', @shows], expires_in: 1.hour
attributes :id, :name, :image_url
child :videos do
	attributes :name, :code, :image_url
end