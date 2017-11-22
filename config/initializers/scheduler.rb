require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.cron '0 9 * * 5' do
  SummaryMailer.new_summary
end

scheduler.cron '55 10 * * 5' do
  # Enable Slack reminder before production release
  # SlackService.instance.send_reminder
end
