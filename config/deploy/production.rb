set :stage, :production

# Replace 127.0.0.1 with your server's IP address!
server '104.131.111.20', user: 'jago', roles: %w{web app}

set :ssh_options, {
  forward_agent: true,
  port: 1525
}