Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == ENV['RESQUE_PASS']
end
