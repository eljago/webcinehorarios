collection @functions
cache ['v1',@functions], expires_in: 1.hour
attributes :date
child :function_types do
	attributes :name
end
glue :show do
	attributes :id, :name, :image
end
child :showtimes do
	attributes :time
end