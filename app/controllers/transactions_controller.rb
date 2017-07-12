class TransactionsController < ApplicationController
  protect_from_forgery with: :exception

  def index
    query_variables
    @transaction = Transaction.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    # TODO implement session authentication
    @transaction = Transaction.new
  end

  def create
    query_variables
    @transaction  = TransactionAdder.create(params[:transaction], current_user)

    if @transaction.save
      flash[:notice] = 'Transaction was successfully created!'
      TransactionMailer.new_transaction(@transaction)
      redirect_to root_path
    else
      flash[:error] = @transaction.errors.full_messages.to_sentence.capitalize
      @transaction.activity.name = @transaction.activity.name.split('for: ')[1]
      render 'index'
    end
  end

  def upvote
    # TODO implement session authentication
    @transaction = Transaction.find(params[:id])
    @transaction.liked_by current_user
    query_variables
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end

    if Balance.current.amount >= Goal.next.amount
      GoalReacher.check!
    end

  end

  def downvote
    # TODO implement session authentication
    @transaction = Transaction.find(params[:id])
    @transaction.unliked_by current_user
    query_variables
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def kudo_guidelines
    kudos = params[:kudo_amount].to_i
    guidelines = Transaction.guidelines_between [(kudos - 10), 0].max, kudos + 10
    render json: guidelines
  end

  private

  def query_variables
    @previous                     = Goal.previous.decorate
    @next                         = Goal.next.decorate
    @iterate_goals                = Goal.goals
    @goals                        = Goal.all.order(:cached_votes_up => :desc)
    @current_goals                = Goal.all.where(balance: Balance.current).order('amount desc')

    @balance                      = Balance.current.decorate
    @achieved_goal                = Goal.where(balance: Balance.current).where.not(achieved_on: nil).order('achieved_on desc')

    @send_transactions_user       = Transaction.where(sender: current_user).count(:id)
    @received_transactions_user   = Transaction.where(receiver: current_user).count(:id)
    @received_transactions_team   = Transaction.where(receiver: User.where(name: ENV.fetch('COMPANY_USER', 'Kabisa'))).count(:id)
    @all_transactions_user        = @send_transactions_user + @received_transactions_user + @received_transactions_team

    @weekly_transactions          = Transaction.where(balance: Balance.current).where(created_at: (Time.now.beginning_of_week(start_day = :monday)..Time.now.end_of_week())).count(:id)
    @monthly_transactions         = Transaction.where(balance: Balance.current).where(created_at: (Time.now.beginning_of_month..Time.now.end_of_month)).count(:id)
    @all_transactions             = Transaction.count(:id)

    @weekly_likes                 = Transaction.joins("INNER JOIN votes on votes.votable_id = transactions.id and votable_type='Transaction'").where("balance_id=#{Balance.current.id}").where(created_at: (Time.now.beginning_of_week(start_day = :monday)..Time.now.end_of_week())).count
    @monthly_likes                = Transaction.joins("INNER JOIN votes on votes.votable_id = transactions.id and votable_type='Transaction'").where("balance_id=#{Balance.current.id}").where(created_at: (Time.now.beginning_of_month..Time.now.end_of_month())).count

    @weekly_kudos                 = Transaction.where(balance: Balance.current).where(created_at: (Time.now.beginning_of_week(start_day = :monday)..Time.now.end_of_week())).sum(:amount) + @weekly_likes
    @monthly_kudos                = Transaction.where(balance: Balance.current).where(created_at: (Time.now.beginning_of_month..Time.now.end_of_month)).sum(:amount) + @monthly_likes

    @markdown                     = Redcarpet::Markdown.new(MdEmoji::Render, :no_intra_emphasis => true)

    if params['filter'] == 'mine'
      @transactions = Transaction.all_for_user(current_user).page(params[:page]).per(20)
    elsif params['filter'] == 'send'
      @transactions = Transaction.send_by_user(current_user).page(params[:page]).per(20)
    elsif params['filter'] == 'received'
      @transactions = Transaction.received_by_user(current_user).page(params[:page]).per(20)
    else
      @transactions = Transaction.order('created_at desc').page(params[:page]).per(20)
    end

  end
end
