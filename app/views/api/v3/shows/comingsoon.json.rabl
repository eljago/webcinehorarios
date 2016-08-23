collection @shows => :movies

attributes :id, :name, :image_url, :name_original
glue :portrait_image do
	attributes :image_url => :portrait_image
end
node :debut do |s|
	s.debut.blank? ? nil : I18n.l(s.debut, format: :normal).capitalize
end