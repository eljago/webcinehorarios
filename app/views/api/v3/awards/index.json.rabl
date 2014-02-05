collection @awards => :awards
cache ['v3', Digest::MD5.hexdigest(@awards.map(&:id).join(','))], expires_in: 1.hour
attributes :id, :name, :date, :image
child :award_specific_categories do
	attributes :id, :name, :award_id, :award_category_id
	
	child :nominations do
		attributes :id, :winner, :type, :show_id
		
		child :nomination_person_roles do
			attributes :person_id
		end
	end
end
child :award_type do
	attributes :id, :name
end