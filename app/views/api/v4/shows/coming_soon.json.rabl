collection @shows => :coming_soon

cache ['v4', Digest::MD5.hexdigest(@shows.map(&:id).join(','))], expires_in: 30.minutes

attributes :id, :name, :image_url, :name_original

node :portrait_image do |s|
  if s.images.where(backdrop: true).length > 0
    s.images.where(backdrop: true).first.image_url
  else
    "/uploads/default_images/default.png"
  end
end

node :debut do |s|
	s.debut.blank? ? nil : I18n.l(s.debut, format: :normal).capitalize
end