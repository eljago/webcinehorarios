collection @favorite_theaters => :theaters

cache ['v4', Digest::MD5.hexdigest(@favorite_theaters.map(&:id).join(','))], expires_in: 30.minutes

attributes :id, :name, :cinema_id, :latitude, :longitude, :information, :address, :web_url