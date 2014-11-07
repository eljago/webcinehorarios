collection @theaters
cache ['v3', @show_id, @theaters], expires_in: 30.minutes
attributes :id, :name, :cinema_id