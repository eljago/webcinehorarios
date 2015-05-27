collection @theaters => :theaters

cache ['v4', @date.strftime('%Y%m%d'), @show_id, Digest::MD5.hexdigest(@theaters.map(&:id).join(','))], expires_in: 30.minutes

attributes :id, :name, :cinema_id

node do |t|
	functions = t.functions.where(show_id: @show_id, date: @date).includes(:function_types, :showtimes).order('function_types.name, showtimes.time').select('showtimes.time, function_types.name')
	{ functions: partial('api/v4/shows/_functions', object: functions) }
end