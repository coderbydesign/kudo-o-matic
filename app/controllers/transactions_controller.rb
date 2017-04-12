class TransactionsController < ApplicationController
  def index

  end

  def new
    # TODO implement session authentication
    @transaction = Transaction.new

    # if @transaction.save
    #   redirect_to root_path
    # else
    #   render 'new'
    # end

  end

  def create
    @transaction = TransactionAdder.create(params[:transaction], current_user)

    if @transaction.save
      flash[:notice] = 'Transaction was successfully created!'
      redirect_to root_path
    else
      flash[:error] = @transaction.errors.full_messages.to_sentence.capitalize
      redirect_to root_path
    end
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
