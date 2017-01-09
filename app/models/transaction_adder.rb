class TransactionAdder
  def self.create(params, current_user)
    receiver = User.where(name: params[:receiver]).first
    name  = params[:activity].to_s.downcase
    name = "#{params[:receiver]} for: #{name}" if receiver.nil?
    activity = Activity.find_or_create_by(name: name)

    transaction = Transaction.new(
        sender: current_user,
        receiver: receiver,
        activity: activity,
        balance: Balance.current,
        amount: params[:amount]
      )

    Transaction.transaction do
      transaction.save
      Balance.current.add(params[:amount])
      GoalReacher.check!
    end

    transaction
  end

end
