require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

unless defined?(Rails::Console) || File.split($0).last == 'rake' || Rails.env == 'staging'
  scheduler.cron '0 9 * * 5' do
    SummaryMailer.new_summary
  end

  scheduler.cron '55 10 * * 5' do
    SlackService.instance.send_reminder
    FcmService.instance.send_reminder
  end
end

scheduler.cron '5 0 * * *' do
  ExportService.instance.delete_expired_exports
end