object @theater
cache ['v3', @cache_date, [Digest::MD5.hexdigest(@functions.map(&:id).join(','))]], expires_in: 30.minutes
attributes :id, :name
node :date do
	@date
end
node :web_url do
	@theater.web_url
end
node :address do
	@theater.address
end
node :latitude do
	@theater.latitude
end
node :longitude do
	@theater.longitude
end
node :information do
	@theater.information
end
node :cinema_id do
	@theater.cinema_id
end
node :functions do
	partial "api/v3/functions/functions", object: @functions 
end