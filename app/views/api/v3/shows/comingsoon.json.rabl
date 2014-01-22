collection @shows => :movies
cache ['v3', Digest::MD5.hexdigest(@shows.map(&:id).join(','))], expires_in: 1.hour
attributes :id, :name, :image_url, :name_original
glue :portrait_image do
	attributes :image_url => :portrait_image
end
node :debut do |s|
	s.debut.blank? ? nil : l(s.debut, format: :longi).capitalize
end