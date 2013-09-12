object @cinema
cache ['v2', @cinema], expires_in: 1.hour
attributes :id, :name
child :theaters do
	attributes :id, :name
end