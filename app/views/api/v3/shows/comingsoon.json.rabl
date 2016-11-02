collection @shows => :movies

attributes :id, :name, :name_original
node :image_url do |s|
  s.image_url
end
node :portrait_image do |s|
  s.portrait_image
end
node :debut do |s|
	s.debut.blank? ? nil : I18n.l(s.debut, format: :normal).capitalize
end