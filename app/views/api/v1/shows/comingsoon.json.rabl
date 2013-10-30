collection @shows
cache ['v1', @shows.map(&:id)], expires_in: 1.hour
attributes :id, :name, :image, :name_original, :debut