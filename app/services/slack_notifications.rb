require 'slack-notifier'

class SlackNotifications
   include Rails.application.routes.url_helpers

   attr_reader :transaction

   def initialize(transaction)
     @transaction = transaction
   end

   def notify_slack!
     send_to_channel
     # send_to_user
   end

  def send_to_channel
    return unless Rails.env == 'development'
    notifier = Slack::Notifier.new ENV.fetch('SLACK_WEBHOOK_URL')

    notifier.ping(
        channel: '#testkudo',
        attachments: [
            {
                fallback: 'New transaction',
                color: '#B58342',
                pretext: "Awesome, a new kudo transaction! Only #{kudos_until_goal} ₭ left until the next goal has been reached! <#{root_url}|Click here> for more details.",
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
                footer: "#{Settings.slack.company_name} | #{Settings.slack.company_project} | #{transaction.created_at}",
                footer_icon: Settings.slack.company_icon
            }
        ]
    )
  end

  def receiver_slack_mention
    if not (transaction.receiver_id.present? || transaction.receiver.slack_name.present?)
      ''
    else
      " (<@#{transaction.receiver.slack_name}>)"
    end
  end

  def kudos_until_goal
    Goal.next.amount - (Balance.current.amount + transaction.amount)
  end
end