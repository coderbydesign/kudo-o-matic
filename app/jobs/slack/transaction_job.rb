Slack::TransactionJob = Struct.new(:transaction, :new?) do
  include Rails.application.routes.url_helpers

  def perform
    uri = URI.parse("https://slack.com/api/#{new? ? 'chat.postMessage' : 'chat.update'}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {
        'Content-type' => 'application/json',
        'Authorization' => "Bearer #{ENV['SLACK_BOT_ACCESS_TOKEN']}"}
    )

    deterministic_random_index = Digest::MD5.hexdigest(transaction.id.to_s).to_i
    adjective = %w(Great Awesome Terrific Fantastic Excellent Wonderful Amazing Cool)[deterministic_random_index % length]
    emoji = %w(:+1: :ok_hand: :v: :raised_hands: :clap:)[deterministic_random_index % length]

    settings = Settings.slack

    request.body = {
        ts: transaction.slack_transaction_updated_at,
        channel: ENV['SLACK_CHANNEL'],
        attachments: [
            {
                fallback: 'New ₭udo transaction!',
                color: '#5F90B0',
                pretext: "#{adjective}, a new ₭udo transaction! "\
                         "Only #{transaction.slack_kudos_left_on_creation} ₭ left until the next ₭udo goal is reached! #{emoji}\n"\
                         "Click <#{transaction_url(transaction)}|here> for more details.",
                fields: [
                    {
                        title: 'Sender',
                        value: transaction.sender.name,
                        short: true
                    },
                    {
                        title: 'Receiver',
                        value: "#{transaction.receiver_name_feed} "\
                               "#{!transaction.receiver&.slack_name.blank? ? "(<@#{transaction.receiver.slack_name}>)" : ''}",
                        short: true
                    },
                    {
                        title: 'Description',
                        value: transaction.activity_name_feed.capitalize,
                        short: true
                    },
                    {
                        title: '₭udos',
                        value: "#{transaction.amount} ₭ #{transaction.likes_amount > 0 ? "+ #{transaction.likes_amount} :+1:" : ''}",
                        short: true
                    }
                ],
                footer: "#{ENV['COMPANY_USER']} | ₭udo-o-Matic | Transaction created at: #{(transaction.created_at + 60).strftime('%d-%m-%Y %H:%M')}",
                footer_icon: ENV['COMPANY_ICON'],
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

    response = http.request(request)
    body = JSON.parse(response.body)
    transaction.update(slack_transaction_updated_at: body['ts'])
  end

  def queue_name
    'slack'
  end
end
