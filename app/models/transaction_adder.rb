class TransactionAdder
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
    text = params['text']
    arguments = params['text'].split.size

    amount = text[/^(.+?) /]
    activity = text[/.for (.*)/, 1]
    sender = User.find_by_slack_id(params['user_id'])

    receiver_text = text[/to @(.*?) for/m, 1]
    receiver = User.find_by_slack_name(receiver_text)
    receiver = User.find_by_slack_username(receiver_text) if receiver.nil?

    raise SlackArgumentsError.new("Invalid command. Use the following syntax to give ₭udo's:\n"\
                                  '*/kudo* <amount> *to* @receiver *for* <reason>') if arguments < 5 ||amount.nil? || activity.nil?
    raise SlackConnectionError.new('You are *not* connected to the ₭udo-o-Matic') if sender.nil?
    raise SlackConnectionError.new('Receiver is *not* connected to the ₭udo-o-Matic') if receiver.nil?

    transaction = Transaction.new(
        amount: amount,
        activity: Activity.find_or_create_by(name: activity),
        sender: sender,
        receiver: receiver,
        balance: Balance.current
    )

    save transaction
  end

  def self.create_from_slack_reaction(params, message)
    event = params['event']
    sender = User.find_by_slack_id(event['user'])
    receiver = User.find_by_slack_id(message['user'])

    raise SlackConnectionError.new('You are *not* connected to the ₭udo-o-Matic') if sender.nil?
    raise SlackConnectionError.new('Message is *not* sent by a connected ₭udo-o-Matic user') if receiver.nil?

    transaction = Transaction.new(
        amount: 1,
        activity: Activity.find_or_create_by(name: "Slack message: '#{message['text']}'"),
        sender: sender,
        receiver: receiver,
        balance: Balance.current,
        slack_reaction_created_at: event['item']['ts']
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
