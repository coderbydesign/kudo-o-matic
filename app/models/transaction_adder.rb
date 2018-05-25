# frozen_string_literal: true

class TransactionAdder
  include Slack::Messages

  def self.create(params, current_user, current_team)
    amount = params[:amount]
    receiver_name = params[:receiver_name]
    receiver = User.where(name: receiver_name).first
    activity = params[:activity_name].to_s.downcase
    activity = "#{receiver_name} for: #{activity}" if receiver.nil?

    transaction = Transaction.new(
      amount: amount,
      activity: Activity.find_or_create_by(name: activity),
      image: params[:image],
      sender: current_user,
      receiver: receiver,
      team_id: current_team.id,
      slack_kudos_left_on_creation: Goal.next(current_team).amount - Balance.current(current_team).amount - amount.to_i,
      balance: Balance.current(current_team)
    )

    save transaction, current_team
  rescue
    return transaction
  end

  def self.create_from_api_request(headers, params)
    data = params[:data]
    current_team = headers['Team']
    attributes = data[:attributes]

    amount = attributes[:amount]
    receiver_name = data[:relationships][:receiver][:data][:name]
    receiver = User.where(name: receiver_name).first
    activity = attributes[:activity]
    activity = "#{receiver_name} for: #{activity}" if receiver.nil?

    transaction = Transaction.new(
      amount: amount,
      activity: Activity.find_or_create_by(name: activity),
      sender: User.find_by_api_token(headers['Api-Token']),
      receiver: receiver,
      slack_kudos_left_on_creation: Goal.next(current_team).amount - Balance.current(current_team).amount - amount.to_i,
      balance: Balance.current(current_team),
      team_id: current_team
    )

    unless attributes[:image].nil? || attributes['image-file-type'].nil?
      file_type = attributes['image-file-type']
      transaction.update(
        image: "data:image/#{file_type};base64,#{attributes[:image]}", image_file_name: "image.#{file_type}"
      )
    end

    save(transaction, current_team)
  end

  def self.create_from_slack_command(params, team)
    text = Formatting.unescape(params['text'])
    arguments = text.split(' ', 3)

    receiver_text = arguments[0]
    amount = arguments[1]
    activity = arguments[2]

    first_char_receiver = receiver_text[0]
    receiver_text[0] = ''

    sender_slack_id = params['user_id']

    if arguments.size < 3 || receiver_text.nil? ||
       sender_slack_id.nil? || amount.nil? || activity.nil? || first_char_receiver != '@'
      raise SlackArgumentsError, "Invalid command. Use the following syntax to give ₭udos:\n"\
                                    '*/kudo* @receiver <amount> <reason>'
    end

    receiver = User.find_by_slack_username(receiver_text)
    receiver = User.find_by_slack_name(receiver_text) if receiver.nil?
    sender = User.find_by_slack_id(sender_slack_id)

    # raise SlackConnectionError, 'You are not allowed to post in this team' unless team.member_of?(sender)
    raise SlackConnectionError, 'You are *not* connected to the ₭udo-o-Matic' if sender.nil?
    raise SlackConnectionError, 'Receiver is *not* connected to the ₭udo-o-Matic' if receiver.nil?

    transaction = Transaction.new(
      amount: amount,
      activity: Activity.find_or_create_by(name: activity),
      sender: sender,
      receiver: receiver,
      slack_kudos_left_on_creation: Goal.next(team.id).amount - Balance.current(team.id).amount - amount.to_i,
      balance: Balance.current(team.id),
      team_id: team.id
    )

    save(transaction, team)
  end

  def self.create_from_slack_reaction(sender_slack_id, receiver_slack_id, activity, timestamp, team)
    sender = sender_slack_id.present? ? User.find_by_slack_id(sender_slack_id) : nil
    receiver = receiver_slack_id.present? ? User.find_by_slack_id(receiver_slack_id) : nil

    raise SlackConnectionError, 'You are *not* connected to the ₭udo-o-Matic' if sender.nil?
    raise SlackConnectionError, 'Message is *not* sent by a connected ₭udo-o-Matic user' if receiver.nil?

    transaction = Transaction.new(
      amount: 1,
      activity: Activity.find_or_create_by(name: "Slack message: '#{activity}'"),
      sender: sender,
      receiver: receiver,
      slack_reaction_created_at: timestamp,
      slack_kudos_left_on_creation: Goal.next(team.id).amount - Balance.current(team.id).amount - 1,
      balance: Balance.current(team.id),
      team_id: team.id
    )

    save(transaction, team)
  end

  def self.create_for_new_team(team, current_user)
    Transaction.create(
      amount: 1,
      activity: Activity.find_or_create_by(name: "creating a new team!"),
      sender: team.users.find_by_company_user(true),
      receiver: current_user,
      slack_kudos_left_on_creation: Goal.next(team.id).amount - Balance.current(team.id).amount - 1,
      balance: Balance.current(team.id),
      team_id: team.id
    )
  end

  private

  def self.save(transaction, current_team)
    transaction.save!

    SlackService.instance.send_new_transaction(transaction)
    FcmService.instance.send_new_transaction(transaction)
    TransactionMailer.new_transaction(transaction)

    GoalReacher.check!(current_team)

    transaction
  end
end
