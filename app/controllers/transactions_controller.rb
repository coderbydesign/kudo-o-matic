class TransactionsController < ApplicationController
  def new
    # TODO implement session authentication
    @transaction = Transaction.new
  end

  def create
    @transaction = TransactionAdder.create(params[:transaction])
    redirect_to root_path
  end

  def upvote
    # TODO implement session authentication
    @transaction = Transaction.find(params[:id])
    @transaction.liked_by User.first
    redirect_to root_path
  end

end
