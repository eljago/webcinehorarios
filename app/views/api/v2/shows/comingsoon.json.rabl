collection @shows
cache ['v2', Digest::MD5.hexdigest(@shows.map(&:id).join(','))], expires_in: 1.hour
attributes :id, :name, :image_url, :name_original, :debut
node :portrait_image do |s|
  if s.images.where(backdrop: true).length > 0
    s.images.where(backdrop: true).first.image_url
  else
    "/uploads/default_images/default.png"
  end
end