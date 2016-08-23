object @cinema

attributes :id, :name
child :theaters do
	attributes :id, :name, :web_url, :address, :latitude, :longitude, :information, :cinema_id
end