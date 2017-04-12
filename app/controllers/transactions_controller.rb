class TransactionsController < ApplicationController
  def index

  end

  def new
    # TODO implement session authentication
    @transaction = Transaction.new

    if params['filter'] == 'mine'
      @transactions = Transaction.all_for_user(current_user)
    elsif params['filter'] == 'send'
      @transactions = Transaction.send_by_user(current_user)
    elsif params['filter'] == 'send'
      @transactions = Transaction.received_by_user(current_user)
    else
      @transactions = Transaction.order('created_at desc').page(params[:page]).per(20)
    end

    respond_to do |format|
      format.html
      format.js
    end

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
