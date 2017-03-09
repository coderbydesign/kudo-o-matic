require 'slack-notifier'

class SlackNotifications

  def self.send_kudo_transaction_to_channel(transaction)
    return unless Rails.env == 'development'
    notifier = Slack::Notifier.new ENV.fetch('SLACK_WEBHOOK_URL')

    notifier.ping(
        channel: '#testkudo',
        attachments: [
            {
                fallback: 'New transaction',
                color: '#B58342',
                pretext: "<!channel> A new kudo transaction has been made! <#{ENV['ROOT_URL']}|Click here> for more details.",
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
                        value: '₭ ' + transaction.amount.to_s,
                        short: true
                    }
                ],
                footer: 'Kabisa | ₭udos Platform | ' + transaction.created_at.to_s,
                footer_icon: 'https://pbs.twimg.com/profile_images/2203769368/kabisa_lizard_400x400.png'
            }
        ]
    )
  end

  def self.send_kudo_transaction_to_user(transaction)
    return unless Rails.env == 'development'
    notifier = Slack::Notifier.new ENV.fetch('SLACK_WEBHOOK_URL')

    notifier.ping(
        channel: '@' + transaction.receiver.slack_name,
        attachments: [
            {
                fallback: 'New transaction',
                color: '#B58342',
                pretext: "#{transaction.sender.name} (<@#{transaction.sender.slack_name}>) awarded you ₭ #{transaction.amount.to_s} for #{transaction.activity_name.capitalize}! <#{ENV['ROOT_URL']}|Click here> for more details.",
                footer: 'Kabisa | ₭udos Platform | ' + transaction.created_at.to_s,
                footer_icon: 'https://pbs.twimg.com/profile_images/2203769368/kabisa_lizard_400x400.png'
            }
        ]
    )
  end
end