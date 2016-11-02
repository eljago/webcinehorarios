collection @favorite_theaters

attributes :id, :name, :cinema_id

node :date do
	@date
end

child :functions do

	attributes :showtimes

	node :function_types do |f|
		f.function_types.order('function_types.name ASC').select(:name).map do |ft|
			ft.name
		end.join(', ')
	end
	
	glue :show do
		attributes :id, :name
		node :image_url do |s|
		  s.image_url
		end
		node :portrait_image do |s|
		  s.portrait_image
		end
	end
end