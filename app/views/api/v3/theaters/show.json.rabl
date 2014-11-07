object @theater
cache ['v3', @cache_date, [Digest::MD5.hexdigest(@functions.map(&:id).join(','))]], expires_in: 30.minutes
attributes :id, :name
node :date do
	@date
end
node :web_url do
	if @cinema_name == "Cine Hoyts"
		date = @date.to_s.split('-').reverse.join('-')
		"#{@theater.web_url}&fecha=#{date}"
	else
		@theater.web_url
	end
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