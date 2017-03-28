require 'slack-notifier'

class SlackNotifications
   include Rails.application.routes.url_helpers

   attr_reader :transaction, :enabled

   def initialize(transaction, enabled: !Rails.env.test?)
     @transaction = transaction
     @enabled = enabled
   end

  def send_new_transaction
    slack_webhook_url = ENV['SLACK_WEBHOOK_URL']
    return if slack_webhook_url.nil? || !enabled
    notifier = Slack::Notifier.new slack_webhook_url

    notifier.ping(
        channel: ENV.fetch('SLACK_CHANNEL', '#kudo'),
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
                        value: transaction.receiver_name_feed + receiver_slack_mention,
                        short: true
                    },
                    {
                        title: 'Kudos given for',
                        value: transaction.activity_name_feed.capitalize,
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
    slack_webhook_url = ENV['SLACK_WEBHOOK_URL']
    return if slack_webhook_url.nil? || !enabled
    notifier = Slack::Notifier.new slack_webhook_url

   notifier.ping(
       channel: ENV.fetch('SLACK_CHANNEL', '#kudo'),
       attachments: [
           {
               fallback: 'New goal achieved!',
               color: '#B58342',
               pretext: "<!channel> Great!! You and your colleagues just achieved a goal so don't forget to pick a date!\nThe achieved goal is: #{Goal.previous.name}! <#{root_url}|Click here> for more details.",
               footer: "#{Settings.slack.company_name} | #{Settings.slack.company_project} | Achieved on: #{Goal.previous.achieved_on}",
               footer_icon: Settings.slack.company_icon
           }
       ]
   )
  end

  def receiver_slack_mention
    if transaction.receiver.try(:slack_name)
      " (<@#{transaction.receiver.slack_name}>)"
    else
      ''
    end
  end

  def kudos_until_goal
    kudos_left = Goal.next.amount - Balance.current.amount
    "Only #{kudos_left} ₭ left until the next goal has been reached! "
  end
end