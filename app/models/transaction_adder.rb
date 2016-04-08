class TransactionAdder

  def self.create(params)
    sender = User.find_or_create(name: params[:sender])

  end

end
