require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.cron '0 9 * * 5' do
  SummaryMailer.new_summary
end

scheduler.cron '0 9 * * 5' do
  SlackService.instance.send_reminder
end
