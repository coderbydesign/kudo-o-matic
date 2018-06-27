# frozen_string_literal: true

class SlackService
  include Singleton
  include Rails.application.routes.url_helpers

  def send_new_transaction(transaction, team)
    return unless SLACK_IS_CONFIGURED

    Delayed::Job.enqueue Slack::TransactionJob.new(transaction, team, true)
  end

  def send_updated_transaction(transaction)
    return unless SLACK_IS_CONFIGURED

    Delayed::Job.enqueue Slack::TransactionJob.new(transaction, transaction.team, false)
  end

  def send_goal_reached(team)
    return unless SLACK_IS_CONFIGURED

    Delayed::Job.enqueue Slack::GoalJob.new(team)
  end

  def send_reminder
    return unless SLACK_IS_CONFIGURED

    Team.where.not(slack_team_id: nil).each do |t|
      Delayed::Job.enqueue Slack::ReminderJob.new(t)
    end
  end

  def send_response(response_url, message, team)
    return unless SLACK_IS_CONFIGURED

    uri = URI.parse(response_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, 'Content-type' => 'application/json',
                                            'Authorization' => "Bearer #{team.slack_bot_access_token}")

    request.body = {
      response_type: 'ephemeral',
      replace_original: false,
      text: message
    }.to_json

    http.request(request)
  end

  def send_ephemeral_message(channel, user, message, team)
    return unless SLACK_IS_CONFIGURED

    uri = URI.parse('https://slack.com/api/chat.postEphemeral')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, 'Content-type' => 'application/json',
                                            'Authorization' => "Bearer #{team.slack_bot_access_token}")

    request.body = {
      channel: channel,
      user: user,
      text: message
    }.to_json

    http.request(request)
  end

  def retrieve_message(channel, timestamp)
    return unless SLACK_IS_CONFIGURED

    uri = URI.parse('https://slack.com/api/channels.history')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, 'Content-type' => 'application/x-www-form-urlencoded')

    request.body = URI.encode_www_form(
      token: ENV['SLACK_ACCESS_TOKEN'],
      channel: channel,
      latest: timestamp,
      inclusive: true,
      count: 1
    )

    response = http.request(request).body

    JSON.parse(response)['messages'][0]
  end

  def convert_user_id_to_user_name(user_id)
    return unless SLACK_IS_CONFIGURED

    uri = URI.parse('https://slack.com/api/users.info')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, 'Content-type' => 'application/x-www-form-urlencoded')

    request.body = URI.encode_www_form(
      token: ENV['SLACK_ACCESS_TOKEN'],
      user: user_id
    )

    response = http.request(request).body

    user = JSON.parse(response)['user']
    user['profile']['display_name'] unless user.nil?
  end
end
