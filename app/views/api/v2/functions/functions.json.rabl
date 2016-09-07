collection @functions
cache ['v2', @functions], expires_in: 1.hour
child :function_types do
	attributes :name
end
glue :show do
	attributes :id, :name, :image_url
  node :portrait_image do |s|
    if s.images.where(backdrop: true).length > 0
      s.images.where(backdrop: true).first.image_url
    else
      "/uploads/default_images/default.png"
    end
  end
end
node :showtimes do |f|
	f.showtimes.order('showtimes.time ASC').select(:time).map do |showtime|
		{time: showtime.time.to_s.gsub(/ -0300/,"Z").sub(' ',"T")}
	end
end