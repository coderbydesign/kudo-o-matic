# frozen_string_literal: true

Slack::GoalJob = Struct.new(:team) do
  include Rails.application.routes.url_helpers

  def perform
    uri = URI.parse('https://slack.com/api/chat.postMessage')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, 'Content-type' => 'application/json',
                                            'Authorization' => "Bearer #{team.slack_bot_access_token}")

    goal = Goal.previous(team)

    request.body = {
      channel: ENV['SLACK_CHANNEL'],
      attachments:
            [
              {
                text: "<!channel> Congratulations! :tada:\n"\
                        "You and your colleagues just <#{dashboard_url(team: team.slug)}|achieved> ₭udo goal *'#{goal.name}'*! :confetti_ball: \n\n"\
                        "Don't forget to pick a date!",
                mrkdwn_in: ['text'],
                fallback: '₭udo goal achieved! :trophy:',
                color: '#5F90B0',
                footer: "#{ENV['COMPANY_USER']} | ₭udo-o-Matic | "\
                          "<#{dashboard_url(team: team.slug)}|Goal> achieved on: #{goal.achieved_on.in_time_zone('CET').strftime('%d-%m-%Y')}",
                footer_icon: ENV['COMPANY_ICON']
              }
            ]
    }.to_json

    http.request(request)
  end

  def queue_name
    'slack'
  end
end
