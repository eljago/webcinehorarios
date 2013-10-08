collection @functions
cache ['v2', @functions], expires_in: 1.hour
attributes :date
child :function_types do
	attributes :name
end
child :showtimes do
	attributes :time
end