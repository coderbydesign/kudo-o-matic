class SlackService
  include Singleton
  include Rails.application.routes.url_helpers

  GREETINGS = %w(Hi Hey Hello)
  ADJECTIVES = %w(Great Awesome Terrific Fantastic Excellent Wonderful Amazing Cool)
  TRANSACTION_EMOJI = %w(:+1: :ok_hand: :v: :raised_hands: :clap:)
  GOAL_EMOJI = %w(:confetti_ball: :tada:)

  def send_new_transaction(transaction)
    return if slack_not_configured

    uri = URI.parse('https://slack.com/api/chat.postMessage')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {'Content-type' => 'application/json', 'Authorization' => "Bearer #{ENV['SLACK_BOT_ACCESS_TOKEN']}"})

    request.body = {
        channel: ENV['SLACK_CHANNEL'],
        attachments: [
            {
                fallback: 'New ₭udo transaction!',
                color: '#5F90B0',
                pretext: "#{ADJECTIVES.sample}, a new ₭udo transaction! "\
                         "Only #{Goal.next.amount - Balance.current.amount} ₭ left until the next ₭udo goal is reached! #{TRANSACTION_EMOJI.sample}\n"\
                         "Click <#{transaction_url(transaction)}|here> for more details.",
                fields: [
                    {
                        title: '₭udos given by',
                        value: transaction.sender.name,
                        short: true
                    },
                    {
                        title: '₭udos given to',
                        value: "#{transaction.receiver_name_feed} "\
                               "#{!transaction.receiver&.slack_name.blank? ? "(<@#{transaction.receiver.slack_name}>)" : ''}",
                        short: true
                    },
                    {
                        title: '₭udos given for',
                        value: transaction.activity_name_feed.capitalize,
                        short: true
                    },
                    {
                        title: 'Amount of ₭udos',
                        value: "#{transaction.amount} ₭",
                        short: true
                    }
                ],
                footer: "#{Settings.slack.company_name} | #{Settings.slack.company_project} | Transaction created at: #{transaction.created_at}",
                footer_icon: Settings.slack.company_icon,
                image_url: transaction.image.url(:thumb),
                callback_id: transaction.id,
                actions: [
                    {
                        name: 'like',
                        text: ':+1: Like',
                        type: 'button',
                        style: 'primary',
                        value: 'true'
                    }
                ]
            }
        ]
    }.to_json

    http.delay(queue: :slack, priority: 1).request(request)
  end

  def update_transaction(payload)
    return if slack_not_configured

    uri = URI.parse('https://slack.com/api/chat.update')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {'Content-type' => 'application/json', 'Authorization' => "Bearer #{ENV['SLACK_BOT_ACCESS_TOKEN']}"})

    attachments = payload['original_message']['attachments']
    attachments[0].delete('actions')

    request.body = {
        token: payload['token'],
        channel: payload['channel']['id'],
        ts: payload['message_ts'],
        response_type: 'ephemeral',
        attachments: attachments
    }.to_json

    http.request(request)
  end

  def send_goal_reached
    return if slack_not_configured

    SLACK_NOTIFIER.delay(queue: :slack, priority: 0).ping(
        attachments:
            [
                {
                    fallback: '₭udo goal achieved! :trophy:',
                    color: '#5F90B0',
                    pretext: "<!channel> Congratulations! You and your colleagues just achieved a ₭udo goal! #{GOAL_EMOJI.sample}\n"\
                             "Don't forget to pick a date! Click <#{root_url}|here> for more details.",
                    fields: [
                        {
                            title: 'Achieved goal',
                            value: Goal.previous.name,
                            short: true
                        },
                        {
                            title: 'Achieved ₭udos',
                            value: "#{Balance.current.amount} ₭",
                            short: true
                        }
                    ],
                    footer: "#{Settings.slack.company_name} | #{Settings.slack.company_project} | Goal achieved on: #{Goal.previous.achieved_on}",
                    footer_icon: Settings.slack.company_icon
                }
            ]
    )
  end

  def send_reminder
    return if slack_not_configured

    User.where(deactivated_at: nil).where.not(slack_id: nil).each do |user|
      SLACK_NOTIFIER.delay(queue: :slack, priority: 2).ping(
          channel: "@#{user.slack_id}",
          attachments:
              [
                  {
                      fallback: '₭udo reminder! :clock11:',
                      color: '#5F90B0',
                      pretext: "#{GREETINGS.sample} #{user.first_name},\n\n"\
                               "It's almost weekend, but don't forget to think back about this week "\
                               "because there is definitely someone who deserves a compliment! :thinking_face:\n\n"\
                               "Click <#{root_url}|here> to give that person some ₭udo's! :+1:",
                      footer: "#{Settings.slack.company_name} | #{Settings.slack.company_project}",
                      footer_icon: Settings.slack.company_icon
                  }
              ]
      )
    end
  end

  def send_response(response_url, response)
    return if slack_not_configured

    uri = URI.parse(response_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {'Content-type' => 'application/json', 'Authorization' => "Bearer #{ENV['SLACK_BOT_ACCESS_TOKEN']}"})

    request.body = {
        response_type: 'emphemeral',
        replace_original: false,
        text: response
    }.to_json

    http.request(request)
  end

  private

  def slack_not_configured
    SLACK_NOTIFIER.nil?
  end
end
