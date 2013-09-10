object false
node :date do
	@date
end
child @functions do
	collection @functions => :functions
	cache ['v2',@functions], expires_in: 1.hour
	child :function_types do
		attributes :name
	end
	glue :show do
		attributes :id, :name, :image
	end
	child :showtimes do
		attributes :time
	end
end