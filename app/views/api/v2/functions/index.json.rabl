object false
node :date do
	@date
end
child @functions do
	collection @functions => :functions
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