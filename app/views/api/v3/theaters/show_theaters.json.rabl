collection @theaters
cache ['v3', @show_id, @theaters], expires_in: 1.hour
attributes :id, :name, :cinema_id