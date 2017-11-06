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

    save_and_check_goal_reached transaction
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

    save_and_check_goal_reached transaction
  end

  private

  def self.save_and_check_goal_reached(transaction)
    Transaction.transaction do
      transaction.save!
      GoalReacher.check!
    end

    TransactionMailer.new_transaction(transaction)

    transaction
  end
end
