collection @functions
glue :show do
	attributes :id, :name, :showtimes
	node :image_url do |s|
	  s.image_url
	end
	node :portrait_image do |s|
	  s.portrait_image
	end
end
node :function_types do |f|
	f.function_types.order('function_types.name ASC').select(:name).map do |function_type|
		function_type.name
	end.join(', ')
end