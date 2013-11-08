collection @theaters
cache ['v2', @show_id, @theaters], expires_in: 1.hour
attributes :id, :name, :cinema_id