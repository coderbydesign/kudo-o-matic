require 'slack-notifier'

class SlackNotifications
   include Rails.application.routes.url_helpers

   attr_reader :transaction

   def initialize(transaction)
     @transaction = transaction
   end

  def send_new_transaction
    return unless Rails.env == 'production'
    notifier = Slack::Notifier.new ENV.fetch('SLACK_WEBHOOK_URL')

    notifier.ping(
        channel: Settings.slack.channel_name,
        attachments: [
            {
                fallback: 'New transaction',
                color: '#B58342',
                pretext: "Awesome, a new kudo transaction! #{kudos_until_goal}<#{root_url}|Click here> for more details.",
                fields: [
                    {
                        title: 'Kudos given by',
                        value: transaction.sender.name,
                        short: true
                    },
                    {
                        title: 'Kudos given to',
                        value: transaction.receiver_name + receiver_slack_mention,
                        short: true
                    },
                    {
                        title: 'Kudos given for',
                        value: transaction.activity_name.capitalize,
                        short: true
                    },
                    {
                        title: 'Amount of Kudos',
                        value: ApplicationController.helpers.number_to_kudos(transaction.amount),
                        short: true
                    }
                ],
                footer: "#{Settings.slack.company_name} | #{Settings.slack.company_project} | Created at: #{transaction.created_at}",
                footer_icon: Settings.slack.company_icon
            }
        ]
    )
  end

  def send_goal_achieved
   return unless Rails.env == 'production'
   notifier = Slack::Notifier.new ENV.fetch('SLACK_WEBHOOK_URL')
   notifier.ping(
       channel: Settings.slack.channel_name,
       attachments: [
           {
               fallback: 'New goal achieved!',
               color: '#B58342',
               pretext: "<!channel> Yess!! You and your colleagues just achieved a new goal so don't forget to pick a date!\nThe achieved goal is: #{Goal.previous.name}! <#{root_url}|Click here> for more details.",
               footer: "#{Settings.slack.company_name} | #{Settings.slack.company_project} | Achieved on: #{Goal.previous.achieved_on}",
               footer_icon: Settings.slack.company_icon
           }
       ]
   )
  end

  def receiver_slack_mention
    if not transaction.receiver_id.present?
      ''
    elsif not transaction.receiver.slack_name.present?
      ''
    else
      " (<@#{transaction.receiver.slack_name}>)"
    end
  end

  def kudos_until_goal
    kudos_left = Goal.next.amount - (Balance.current.amount + transaction.amount)
    if kudos_left > 0
      "Only #{kudos_left} ₭ left until the next goal has been reached! "
    else
      ''
    end
  end
end