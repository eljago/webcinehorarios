collection @videos
cache ['v2', @videos], expires_in: 1.hour
attributes :id, :name, :code, :image_url, :videoable_id, :videoable_type
child :videoable do
	attributes :id, :name, :image_url
end