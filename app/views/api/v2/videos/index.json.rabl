collection @videos
cache ['v2', @videos], expires_in: 1.hour
attributes :id, :name, :code, :image_url