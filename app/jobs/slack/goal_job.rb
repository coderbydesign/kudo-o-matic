Slack::GoalJob = Struct.new(:nil) do
  include Rails.application.routes.url_helpers

  def perform
    uri = URI.parse('https://slack.com/api/chat.postMessage')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {
        'Content-type' => 'application/json',
        'Authorization' => "Bearer #{ENV['SLACK_BOT_ACCESS_TOKEN']}"}
    )

    emoji = %w(:confetti_ball: :tada:).sample

    goal = Goal.previous
    balance = Balance.current
    settings = Settings.slack

    request.body = {
        channel: ENV['SLACK_CHANNEL'],
        attachments:
            [
                {
                    fallback: '₭udo goal achieved! :trophy:',
                    color: '#5F90B0',
                    pretext: "<!channel> Congratulations! You and your colleagues just achieved a ₭udo goal! #{emoji}\n"\
                             "Don't forget to pick a date! Click <#{root_url}|here> for more details.",
                    fields: [
                        {
                            title: 'Goal',
                            value: goal.name,
                            short: true
                        },
                        {
                            title: '₭udos',
                            value: "#{balance.amount} ₭",
                            short: true
                        }
                    ],
                    footer: "#{ENV['COMPANY_USER']} | ₭udo-o-Matic | Goal achieved on: #{goal.achieved_on.strftime('%d-%m-%Y')}",
                    footer_icon: ENV['COMPANY_ICON']
                }
            ]
    }.to_json

    http.request(request)
  end

  def queue_name
    'slack'
  end
end
