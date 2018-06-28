# frozen_string_literal: true

Slack::ReminderJob = Struct.new(:team) do
  include Rails.application.routes.url_helpers

  def perform
    uri = URI.parse('https://slack.com/api/chat.postMessage')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, 'Content-type' => 'application/json',
                                            'Authorization' => "Bearer #{team.slack_bot_access_token}")

    greeting = %w[Hi Hey Hello].sample

    team.memberships.where.not(slack_id: nil).each do |membership|
      next unless membership.user.deactivated_at.nil?
      request.body = {
        channel: membership.slack_id,
        attachments:
              [
                {
                  text: "#{greeting} #{membership.user.first_name},\n\n"\
                         "It's almost weekend, but don't forget to think back about this week "\
                         "because there is definitely someone who *deserves a compliment*! :thinking_face:\n\n"\
                         "Click <#{dashboard_url(team: team.slug)}|here> to give that person some *₭udos*! :+1:",
                  mrkdwn_in: ['text'],
                  fallback: '₭udo reminder! :clock12:',
                  color: '#5F90B0',
                  footer: "#{team.name} | ₭udo-o-Matic",
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
