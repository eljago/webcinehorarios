object false
node :theaters do
	partial "api/v2/theaters/show_theaters_alone", object: @theaters 
end
node :favorite_theaters_functions do
	partial "api/v2/theaters/favorite_theaters_functions", object: @favorite_theaters_functions
end