require 'slack-notifier'

class SlackNotifications

  def self.send_kudo_transaction(transaction)
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
end