class TransactionAdder

  def self.create(params)
    sender = User.find_or_create_by(name: params[:sender])
    receiver = User.find_or_create_by(name: params[:receiver])
    activity = Activity.find_or_create_by(name: params[:activity].to_s.downcase)

    transaction = Transaction.new(
        sender: sender,
        receiver: receiver,
        activity: activity,
        balance: Balance.current,
        amount: params[:amount]
      )

    Transaction.transaction do
      transaction.save!
      Balance.current.add(params[:amount])
      GoalReacher.check!
    end

    transaction
  end

end
