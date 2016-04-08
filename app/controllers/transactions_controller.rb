class TransactionsController < ApplicationController
  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = TransactionAdder.create(params[:transaction])
    redirect_to root_path
  end
end
