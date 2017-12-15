Slack::ReminderJob = Struct.new(:nil) do
  include Rails.application.routes.url_helpers

  def perform
    uri = URI.parse('https://slack.com/api/chat.postMessage')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {
        'Content-type' => 'application/json',
        'Authorization' => "Bearer #{ENV['SLACK_BOT_ACCESS_TOKEN']}"}
    )

    greeting = %w(Hi Hey Hello).sample

    User.where(deactivated_at: nil).where.not(slack_id: nil).each do |user|
      request.body = {
          channel: "@#{user.slack_id}",
          attachments:
              [
                  {
                      text: "#{greeting} #{user.first_name},\n\n"\
                               "It's almost weekend, but don't forget to think back about this week "\
                               "because there is definitely someone who *deserves a compliment*! :thinking_face:\n\n"\
                               "Click <#{root_url}|here> to give that person some *₭udos*! :+1:",
                      mrkdwn_in: ['text'],
                      fallback: '₭udo reminder! :clock12:',
                      color: '#5F90B0',
                      footer: "#{ENV['COMPANY_USER']} | ₭udo-o-Matic",
                      footer_icon: ENV['COMPANY_ICON']
                  }
              ]
      }.to_json

      http.request(request)
    end
  end

  def queue_name
    'slack'
  end
end
