collection @theaters
cache ['v3', @cache_date, @show_id, [Digest::MD5.hexdigest(@theaters.map(&:id).join(','))]], expires_in: 30.minutes
attributes :id, :name, :cinema_id