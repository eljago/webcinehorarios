object @theater
cache ['v3', @theater], expires_in: 1.hour
attributes :id, :name
node :functions do
	partial "api/v3/functions/functions", object: @theater.functions 
end