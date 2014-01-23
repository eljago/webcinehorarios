collection @favorite_theaters
cache ['v3', @show.id, Digest::MD5.hexdigest(@favorite_theaters.map(&:id).join(','))], expires_in: 1.hour
attributes :id, :name, :cinema_id
node :functions do |t|
	partial "api/v3/functions/functions", object: t.functions.includes(:show, :showtimes, :function_types).select('function_types.name, shows.id, shows.name, shows.image, shows.debut, showtimes.time').order('shows.debut DESC, shows.id, showtimes.time ASC').where(functions: { date: @date } ).all
end