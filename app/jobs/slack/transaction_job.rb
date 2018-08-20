# frozen_string_literal: true

Slack::TransactionJob = Struct.new(:transaction, :team, :new?) do
  include Rails.application.routes.url_helpers

  def perform
    uri = URI.parse("https://slack.com/api/#{new? ? 'chat.postMessage' : 'chat.update'}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, 'Content-type' => 'application/json',
                                            'Authorization' => "Bearer #{team.slack_bot_access_token}")

    emoji_array = %w[:+1: :ok_hand: :v: :raised_hands: :clap:]
    emoji = emoji_array[deterministic_random(transaction.id) % emoji_array.length]

    transaction_amount = transaction.amount
    kudos_left = transaction.slack_kudos_left_on_creation

    request.body = {
      ts: transaction.slack_transaction_updated_at,
      channel: team.channel_id,
      attachments: [
        {
          text: "*#{transaction.sender.name}* gave *#{transaction.receiver_name_feed}* "\
                  "#{transaction.receiver&.slack_id.present? ? "(<@#{transaction.receiver.slack_id}>) " : ''}"\
                  "*<#{transaction_url(team: team.slug, id: transaction.id)}|#{transaction_amount} #{'₭udo'.pluralize(transaction_amount)}>* "\
                  "for #{transaction.activity_name_feed}. \n\n"\
                  "#{kudos_left.present? && kudos_left > 0 ? "*#{kudos_left} "\
                  "#{'₭udo'.pluralize(kudos_left)}* left until the next goal! #{emoji}" : ''}",
          mrkdwn_in: ['text'],
          fallback: 'New ₭udo transaction!',
          color: '#5F90B0',
          footer: "#{team.name} | ₭udo-o-Matic | "\
                    "<#{transaction_url(team: team.slug, id: transaction.id)}|Transaction> created at: #{transaction.created_at.in_time_zone('CET').strftime('%d-%m-%Y %H:%M')}",
          footer_icon: ENV['COMPANY_ICON'],
          image_url: transaction.image.url(:thumb),
          callback_id: transaction.id,
          as_user: new? ? false : true,
          actions: [
            {
              name: 'like',
              text: 'Like',
              type: 'button',
              style: 'primary',
              value: 'true'
            },
            transaction.likes_amount > 0 ? {
              name: 'likes',
              text: "+ #{transaction.likes_amount} :+1:",
              type: 'button',
              style: 'default',
              value: 'true'
            } : nil
          ]
        }
      ]
    }.to_json

    response = http.request(request)

    body = JSON.parse(response.body)

    transaction.update_attribute(:slack_transaction_updated_at, body['ts'])
  end

  def queue_name
    'slack'
  end

  private

  def deterministic_random(transaction_id)
    Digest::MD5.hexdigest(transaction_id.to_s).to_i
  end
end
