require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.cron '0 0 10 ? * FRI *' do
  SummaryMailer.new_summary
end
