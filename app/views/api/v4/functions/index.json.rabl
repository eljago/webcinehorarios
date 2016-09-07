collection @shows => :shows

cache ['v4', @cache_date, Digest::MD5.hexdigest(@shows.map(&:id).join(','))], expires_in: 30.minutes

attributes :id, :name, :image_url

node :portrait_image do |s|
  if s.images.where(backdrop: true).length > 0
    s.images.where(backdrop: true).first.image_url
  else
    "/uploads/default_images/default.png"
  end
end
  
node do |s|
	functions = s.functions.where(date: @date, theater_id: params[:theater_id]).includes(:function_types, :showtimes)
  .order('function_types.name, showtimes.time').select('functions.id, functions.date, showtimes.time, function_types.name')
	{ functions: partial('api/v4/shows/_functions', object: functions) }
end