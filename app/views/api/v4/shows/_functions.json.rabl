collection :functions

attributes :id, :date

node :showtimes do |f|
	f.showtimes.map do |showtime|
		I18n.l showtime.time, format: :normal_time
	end.join(", ")
end

node :function_types do |f|
	f.function_types.map do |function_type|
		function_type.name
	end.join(', ')
end