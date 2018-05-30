class SlackController < ApplicationController
  include Slack::Messages

  skip_before_action :verify_authenticity_token, only: [:action, :command, :reaction]
  skip_before_action :authenticate_user!, only: [:action, :command, :reaction]

  def action
    payload = JSON.parse(params['payload'])

    return unless check_verification_token(payload['token'])

    transaction = Transaction.find(payload['callback_id'])
    user = User.find_by_slack_id(payload['user']['id'])

    if user&.member_of?(current_team)
      transaction.liked_by user

      SlackService.instance.send_updated_transaction(transaction)

      message = "Successfully liked ₭udo transaction! Click <#{transaction_url(current_team.slug, transaction)}|here> for more details."
      SlackService.instance.send_response(payload['response_url'], message)
    end
  end

  def command
    return unless check_verification_token(params['token'])

    arguments = params['text'].strip
    raise if arguments.blank? || arguments.casecmp('help') == 0

    transaction = TransactionAdder.create_from_slack_command(params, current_team)

    message = "Successfully created ₭udo transaction! Click <#{transaction_url(current_team.slug, transaction)}|here> for more details."
    SlackService.instance.send_response(params['response_url'], message)
  rescue ActiveRecord::RecordInvalid, SlackConnectionError, SlackArgumentsError => error
    SlackService.instance.send_response(params['response_url'], error)
  rescue
    message = "Use the following syntax to give ₭udos:\n*/kudo* @receiver <amount> <reason>"
    SlackService.instance.send_response(params['response_url'], message)
  end

  def reaction
    return if check_challenge

    event = params['event']
    sender_slack_id = event['user']
    item = event['item']
    timestamp = item['ts']
    channel = item['channel']

    return unless check_verification_token(params['token']) && event['reaction'].in?(ENV['SLACK_REACTION'].split(','))

    transaction = Transaction.find_by_slack_reaction_created_at(timestamp)
    user = User.find_by_slack_id(sender_slack_id)

    if user&.member_of?(current_team)
      transaction.liked_by user

      SlackService.instance.send_updated_transaction(transaction)

      message = "Successfully liked ₭udo transaction! Click <#{transaction_url(current_team, transaction)}|here> for more details."
      SlackService.instance.send_ephemeral_message(channel, sender_slack_id, message)
    else
      message = SlackService.instance.retrieve_message(channel, timestamp)
      receiver_slack_id = message['user']

      activity = Formatting.unescape(message['text']).truncate(120, separator: ' ')
      activity = replace_user_ids_with_user_names(activity)

      transaction = TransactionAdder.create_from_slack_reaction(sender_slack_id, receiver_slack_id, activity, timestamp, current_team)

      message = "Successfully created ₭udo transaction! Click <#{transaction_url(current_team, transaction)}|here> for more details."
      SlackService.instance.send_ephemeral_message(channel, sender_slack_id, message)
    end
  rescue ActiveRecord::RecordInvalid, SlackConnectionError => error
    event = params['event']
    SlackService.instance.send_ephemeral_message(event['item']['channel'], event['user'], error)
  end

  private

  def check_verification_token(token)
    token == ENV['SLACK_VERIFICATION_TOKEN']
  end

  def check_challenge
    challenge = params['challenge']
    challenge.present? ? respond_to {|format| format.json {render json: {challenge: challenge}}} : false
  end

  def replace_user_ids_with_user_names(activity)
    (0 ... activity.length).each do |i|
      if activity[i] == '@'
        possible_slack_id = activity[i + 1, 9]

        slack_display_name = SlackService.instance.convert_user_id_to_user_name(possible_slack_id)

        activity.sub!(possible_slack_id, slack_display_name) unless slack_display_name.nil?
      end
    end

    activity
  end
end
