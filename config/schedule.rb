# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

env :PATH, ENV['PATH']

set :environment, "production"

set :output, "#{path}/log/cron.log"

every 6.hours do
  rake "parse:metacritic"
  rake "cache:carrierwave_clean"
end

every 1.day, at: '4am' do
	rake 'cache:clear_all'
  rake "maintain:functions"
end

every 1.day, at: '5am' do
  command '/sbin/shutdown -r +5'
end

every 30.minutes do
  rake 'parse:cinemark'
  rake 'parse:pavilion'
  rake 'parse:cinestar'
  rake 'parse:antay'
end

every 12.hours do
	rake "parse:cinemark_coming_soon"
end