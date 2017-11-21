begin
  webhook_url = ENV['SLACK_WEBHOOK_URL']
  channel = ENV.fetch('SLACK_CHANNEL')

  valid_config = !Rails.env.test? && webhook_url.present? && channel.present?

  SLACK_NOTIFIER = valid_config ? Slack::Notifier.new(webhook_url, channel: channel) : nil
end
