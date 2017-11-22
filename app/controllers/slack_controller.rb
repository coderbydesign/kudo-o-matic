class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:action, :command]
  skip_before_action :authenticate_user!, only: [:action, :command]

  def action
    payload = JSON.parse(params['payload'])

    return unless check_verification_token(payload['token'])

    transaction = Transaction.find(payload['callback_id'])
    user = User.find_by_slack_id(payload['user']['id'])

    if transactions_path.present? && user.present?
      transaction.liked_by user

      SlackService.instance.update_transaction(payload)

      SlackService.instance.send_response(payload['response_url'], "Successfully liked ₭udo transaction! "\
                                                                   "Click <#{transaction_url(transaction)}|here> for more details.")
    end
  end

  def command
    return unless check_verification_token(params['token'])

    response_url = params['response_url']

    transaction = TransactionAdder.create_from_slack_request(params)

    SlackService.instance.send_response(response_url, "Successfully created ₭udo transaction! "\
                                                      "Click <#{transaction_url(transaction)}|here> for more details.")

  rescue ActiveRecord::RecordInvalid, SlackConnectionError, SlackArgumentsError => error
    SlackService.instance.send_response(params['response_url'], error.message)
  rescue
    SlackService.instance.send_response(params['response_url'], "Use the following syntax to give ₭udo's:\n */kudo* <@receiver> <amount> <reason>")
  end

  private

  def check_verification_token(token)
    token == ENV['SLACK_VERIFICATION_TOKEN']
  end
end
