collection @cities
cache ['v2', @cities], expires_in: 1.hour
attributes :id, :name
node :cinemas do |city|
	@cinemas.map do |cinema|
		{ id: cinema.id, name: cinema.name, theaters:
			cinema.theaters.map do |theater|
				if theater.city_id == city.id
					{ id: theater.id, name: theater.name }
				end
			end.compact
		}
	end
end