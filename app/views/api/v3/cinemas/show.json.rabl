object @cinema
cache ['v3', @cinema.theaters], expires_in: 1.hour
attributes :id, :name
child :theaters do
	attributes :id, :name, :web_url, :address, :latitude, :longitude, :information, :cinema_id
end