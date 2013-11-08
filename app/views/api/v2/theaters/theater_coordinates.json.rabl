collection @theaters
cache ['v2', Digest::MD5.hexdigest(@theaters.map(&:id).join(','))], expires_in: 4.hours
attributes :id, :name, :cinema_id, :latitude, :longitude, :address