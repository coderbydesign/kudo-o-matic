require 'slack-notifier'

class SlackNotifications
   include Rails.application.routes.url_helpers

   attr_reader :transaction

   def initialize(transaction)
     @transaction = transaction
   end

   def notify_slack!
     send_to_channel
     send_to_user
   end

  def send_to_channel
    return unless Rails.env == 'production'
    notifier = Slack::Notifier.new ENV.fetch('SLACK_WEBHOOK_URL')

    notifier.ping(
        channel: '#kudo',
        attachments: [
            {
                fallback: 'New transaction',
                color: '#B58342',
                pretext: "<!channel> A new kudo transaction has been made! <#{root_url}|Click here> for more details.",
                fields: [
                    {
                        title: 'Kudos given by',
                        value: transaction.sender.name,
                        short: true
                    },
                    {
                        title: 'Kudos given to',
                        value: transaction.receiver_name,
                        short: true
                    },
                    {
                        title: 'Kudos given for',
                        value: transaction.activity_name.capitalize,
                        short: true
                    },
                    {
                        title: 'Amount of Kudos',
                        value: transaction.amount.to_s + ' ₭',
                        short: true
                    }
                ],
                footer: "#{Settings.company.footer_name} | #{Settings.project.footer_name} | #{transaction.created_at}",
                footer_icon: Settings.company.footer_icon
            }
        ]
    )
  end

  def send_to_user
    return unless Rails.env == 'production'
    notifier = Slack::Notifier.new ENV.fetch('SLACK_WEBHOOK_URL')

    notifier.ping(
        channel: '@' + transaction.receiver.slack_name,
        attachments: [
            {
                fallback: 'New transaction',
                color: '#B58342',
                pretext: "Awesome! #{transaction.sender.name} (<@#{transaction.sender.slack_name}>) awarded you #{transaction.amount.to_s} ₭ for #{transaction.activity_name.capitalize}.",
                text: "<#{root_url}|Click here> for more details.",
                footer: "#{Settings.company.footer_name} | #{Settings.project.footer_name} | #{transaction.created_at}",
                footer_icon: Settings.company.footer_icon
            }
        ]
    )
  end
end