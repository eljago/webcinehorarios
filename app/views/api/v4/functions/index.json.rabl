collection @shows => :shows

cache ['v4', @cache_date, Digest::MD5.hexdigest(@shows.map(&:id).join(','))], expires_in: 30.minutes

attributes :id, :name, :image_url

glue :portrait_image do
  attributes :image_url => :portrait_image
end
  
node do |s|
	functions = s.functions.where(date: @date, theater_id: params[:theater_id]).includes(:function_types, :showtimes)
  .order('function_types.name, showtimes.time').select('functions.id, functions.date, showtimes.time, function_types.name')
	{ functions: partial('api/v4/shows/_functions', object: functions) }
end