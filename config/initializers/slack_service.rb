begin
  channel = ENV.fetch('SLACK_CHANNEL')

  SLACK_IS_CONFIGURED = !Rails.env.test? && channel.present?
end
