collection @shows
cache ['v1', Digest::MD5.hexdigest(@shows.map(&:cache_key))], expires_in: 1.hour
attributes :id, :name, :image, :name_original, :debut