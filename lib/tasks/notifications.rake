namespace :notifications do
  desc 'Send weekly email summary to all subscribed users'
  task weekly_summary: :environment do
    SummaryMailer.new_summary
  end

  desc 'Send a kudos reminder to all slack users'
  task slack_reminder: :environment do
    SlackService.instance.send_reminder
  end

  desc 'Send a kudos reminder to all mobile users'
  task mobile_reminder: :environment do
    FcmService.instance.send_reminder
  end
end
