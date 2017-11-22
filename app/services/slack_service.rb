class SlackService
  include Singleton
  include Rails.application.routes.url_helpers

  GREETINGS = %w(Hi Hey Hello)
  ADJECTIVES = %w(Great Awesome Terrific Fantastic Excellent Wonderful Amazing Cool)
  TRANSACTION_EMOJI = %w(:+1: :ok_hand: :v: :raised_hands: :clap:)
  GOAL_EMOJI = %w(:confetti_ball: :tada:)

  def send_new_transaction(transaction)
    return if slack_not_configured

    goal = Goal.next
    balance = Balance.current
    settings = Settings.slack

    SLACK_NOTIFIER.delay(queue: :slack, priority: 1).ping(
        attachments: [
            {
                fallback: 'New ₭udo transaction!',
                color: '#B58342',
                pretext: "#{ADJECTIVES.sample}, a new ₭udo transaction! "\
                         "Only #{goal.amount - balance.amount} ₭ left until the next ₭udo goal is reached! #{TRANSACTION_EMOJI.sample}\n"\
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
                footer: "#{settings.company_name} | #{settings.company_project} | Transaction created at: #{transaction.created_at}",
                footer_icon: settings.company_icon,
                image_url: transaction.image.url(:thumb)
            }
        ]
    )
  end

  def send_goal_reached
    return if slack_not_configured

    goal = Goal.previous
    balance = Balance.current
    settings = Settings.slack

    SLACK_NOTIFIER.delay(queue: :slack, priority: 0).ping(
        attachments:
            [
                {
                    fallback: '₭udo goal achieved! :trophy:',
                    color: '#B58342',
                    pretext: "<!channel> Congratulations! You and your colleagues just achieved a ₭udo goal! #{GOAL_EMOJI.sample}\n"\
                             "Don't forget to pick a date! Click <#{root_url}|here> for more details.",
                    fields: [
                        {
                            title: 'Achieved goal',
                            value: goal.name,
                            short: true
                        },
                        {
                            title: 'Achieved ₭udos',
                            value: "#{balance.amount} ₭",
                            short: true
                        }
                    ],
                    footer: "#{settings.company_name} | #{settings.company_project} | Goal achieved on: #{goal.achieved_on}",
                    footer_icon: settings.company_icon
                }
            ]
    )
  end

  def send_reminder
    return if slack_not_configured

    settings = Settings.slack

    User.where(deactivated_at: nil).where.not(slack_id: nil).each do |user|
      SLACK_NOTIFIER.delay(queue: :slack, priority: 2).ping(
          channel: "@#{user.slack_id}",
          attachments:
              [
                  {
                      fallback: '₭udo reminder! :clock11:',
                      color: '#B58342',
                      pretext: "#{GREETINGS.sample} #{user.first_name},\n\n"\
                               "It's almost weekend, but don't forget to think back about this week "\
                               "because there is definitely someone who deserves a compliment! :thinking_face:\n\n"\
                               "Click <#{root_url}|here> to give that person some ₭udo's! :+1:",
                      footer: "#{settings.company_name} | #{settings.company_project}",
                      footer_icon: settings.company_icon
                  }
              ]
      )
    end
  end

  private

  def slack_not_configured
    SLACK_NOTIFIER.nil?
  end
end
