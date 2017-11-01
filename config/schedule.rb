# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, {error: 'log/cron_error_log.log', standard: 'log/cron_log.log'}

every :thursday, at: '03:30 pm' do
  rake 'events:slack'
end

every :friday, at: '10:00 am' do
  rake 'events:email'
end

# Learn more: http://github.com/javan/whenever
