collection @shows
cache ['v1', @shows], expires_in: 1.hour
attributes :id, :name, :image, :name_original, :rating
child :genres do
	attributes :name
end
node :duration do |s|
	s.duration == 0 ? nil : s.duration
end