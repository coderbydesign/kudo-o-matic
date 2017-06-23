class TransactionAdder
  def self.create(params, current_user)
    receiver = User.where(name: params[:receiver_name]).first
    name  = params[:activity_name].to_s.downcase
    name = "#{params[:receiver_name]} for: #{name}" if receiver.nil?
    activity = Activity.find_or_create_by(name: name)
    image = params[:image]
    transaction = Transaction.new(
      sender: current_user,
      receiver: receiver,
      activity: activity,
      image: image,
      balance: Balance.current,
      amount: params[:amount]
    )

    Transaction.transaction do
      transaction.save!
      GoalReacher.check!
    end

    transaction
  rescue
    return transaction
  end

end
