require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.cron '0 10 * * 5' do
  SummaryMailer.new_summary
end
