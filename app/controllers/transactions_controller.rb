class TransactionsController < ApplicationController
  def new
    # TODO implement session authentication
    @transaction = Transaction.new
  end

  def create
    if params[:transaction][:activity].empty? && params[:transaction][:receiver].empty?
      flash[:error] = "Activity and Receiver can't be empty, please retry"
    elsif params[:transaction][:receiver].empty?
      flash[:error] = "Receiver can't be empty, please retry"
    elsif params[:transaction][:activity].empty?
      flash[:error] = "Activity can't be empty, please retry"
    else
      @transaction = TransactionAdder.create(params[:transaction], current_user)
      flash[:error] = @transaction.errors.full_messages.to_sentence
    end
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
