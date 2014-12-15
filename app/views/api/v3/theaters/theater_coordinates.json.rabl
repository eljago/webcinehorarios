collection @theaters => :annotationTheaters
cache ['v3', Digest::MD5.hexdigest(@theaters.map(&:id).join(','))], expires_in: 4.hours
attributes :id, :name, :cinema_id, :latitude, :longitude, :information, :address, :web_url
