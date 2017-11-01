require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.every '30s' do
  SummaryMailer.new_summary
end

# scheduler.cron '0 10 * * 5' do
#   SummaryMailer.new_summary
# end
