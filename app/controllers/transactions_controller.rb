class TransactionsController < ApplicationController
  def new
    # TODO implement session authentication
    @transaction = Transaction.new
  end

  def create
    @transaction = TransactionAdder.create(params[:transaction], current_user)
    redirect_to root_path
  end

  def upvote
    # TODO implement session authentication
    @transaction = Transaction.find(params[:id])
    @transaction.liked_by User.first
    redirect_to root_path
  end

  def kudo_guidelines
    kudos = params[:kudo_amount].to_i
    guidelines = Transaction.guidelines_between [(kudos - 10), 0].max, kudos + 10
    render json: guidelines
  end

end
