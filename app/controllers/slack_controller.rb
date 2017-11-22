class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:action, :command, :reaction]
  skip_before_action :authenticate_user!, only: [:action, :command, :reaction]

  def action
    payload = JSON.parse(params['payload'])

    return unless check_verification_token(payload['token'])

    transaction = Transaction.find(payload['callback_id'])
    user = User.find_by_slack_id(payload['user']['id'])

    if transactions_path.present? && user.present?
      transaction.liked_by user

      SlackService.instance.update_transaction(payload)

      message = "Successfully liked ₭udo transaction! Click <#{transaction_url(transaction)}|here> for more details."
      SlackService.instance.send_response(payload['response_url'], message)
    end
  end

  def command
    return unless check_verification_token(params['token'])

    transaction = TransactionAdder.create_from_slack_command(params)

    response_url = params['response_url']
    message = "Successfully created ₭udo transaction! Click <#{transaction_url(transaction)}|here> for more details."
    SlackService.instance.send_response(response_url, message)
  rescue ActiveRecord::RecordInvalid, SlackConnectionError, SlackArgumentsError => error
    SlackService.instance.send_response(params['response_url'], error)
  rescue
    message = "Use the following syntax to give ₭udo's:\n */kudo* <@receiver> <amount> <reason>"
    SlackService.instance.send_response(params['response_url'], message)
  end

  def reaction
    return if check_challenge

    event = params['event']
    item = event['item']
    channel = item['channel']

    return unless check_verification_token(params['token']) && event['reaction'] == 'kudo'

    kudo_message = SlackService.instance.retrieve_message(channel, item['ts'])
    transaction = TransactionAdder.create_from_slack_reaction(params, kudo_message)

    message = "Successfully created ₭udo transaction! Click <#{transaction_url(transaction)}|here> for more details."
    SlackService.instance.send_ephemeral_message(channel, event['user'], message)
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
end
