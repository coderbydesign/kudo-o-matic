class TransactionAdder
  include Slack::Messages

  def self.create(params, current_user)
    receiver_name = params[:receiver_name]
    receiver = User.where(name: receiver_name).first
    name = params[:activity_name].to_s.downcase
    name = "#{receiver_name} for: #{name}" if receiver.nil?

    transaction = Transaction.new(
        amount: params[:amount],
        activity: Activity.find_or_create_by(name: name),
        image: params[:image],
        sender: current_user,
        receiver: receiver,
        balance: Balance.current
    )

    save transaction
  rescue
    return transaction
  end

  def self.create_from_api_request(headers, params)
    data = params[:data]
    attributes = data[:attributes]

    transaction = Transaction.new(
        amount: attributes[:amount],
        activity: Activity.find_or_create_by(name: attributes[:activity]),
        sender: User.find_by_api_token(headers['Api-Token']),
        receiver: User.find(data[:relationships][:receiver][:data][:id]),
        balance: Balance.current
    )

    unless attributes[:image].nil? || attributes['image-file-type'].nil?
      file_type = attributes['image-file-type']
      transaction.update(image: "data:image/#{file_type};base64,#{attributes[:image]}", image_file_name: "image.#{file_type}")
    end

    save transaction
  end

  def self.create_from_slack_command(params)
    text = Formatting.unescape(params['text'])
    arguments = text.split(' ', 3)

    receiver_text = arguments[0]
    amount = arguments[1]
    activity = arguments[2]

    first_char_receiver = receiver_text[0]
    receiver_text[0] = ''

    raise SlackArgumentsError.new("Invalid command. Use the following syntax to give ₭udos:\n"\
                                  '*/kudo* @receiver <amount> <reason>') if arguments.size < 3 || amount.nil? || activity.nil? || first_char_receiver != '@'

    receiver = User.find_by_slack_username(receiver_text)
    receiver = User.find_by_slack_name(receiver_text) if receiver.nil?
    sender = User.find_by_slack_id(params['user_id'])

    raise SlackConnectionError.new('You are *not* connected to the ₭udo-o-Matic') if sender.nil?
    raise SlackConnectionError.new('Receiver is *not* connected to the ₭udo-o-Matic') if receiver.nil?

    transaction = Transaction.new(
        amount: amount,
        activity: Activity.find_or_create_by(name: activity),
        sender: sender,
        receiver: receiver,
        slack_kudos_left_on_creation: Goal.next.amount - Balance.current.amount - amount.to_i,
        balance: Balance.current,
    )

    save transaction
  end

  def self.create_from_slack_reaction(params, user, activity)
    event = params['event']
    sender = User.find_by_slack_id(event['user'])
    receiver = User.find_by_slack_id(user)

    raise SlackConnectionError.new('You are *not* connected to the ₭udo-o-Matic') if sender.nil?
    raise SlackConnectionError.new('Message is *not* sent by a connected ₭udo-o-Matic user') if receiver.nil?

    transaction = Transaction.new(
        amount: 1,
        activity: Activity.find_or_create_by(name: "Slack message: '#{activity}'"),
        sender: sender,
        receiver: receiver,
        slack_reaction_created_at: event['item']['ts'],
        slack_kudos_left_on_creation: Goal.next.amount - Balance.current.amount - 1,
        balance: Balance.current
    )

    save transaction
  end

  private

  def self.save(transaction)
    transaction.save!

    GoalReacher.check!

    TransactionMailer.new_transaction(transaction)

    transaction
  end
end
