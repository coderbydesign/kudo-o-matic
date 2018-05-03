class TransactionsController < ApplicationController
  protect_from_forgery with: :exception

  before_action :query_variables, only: [:index, :show, :create, :upvote, :downvote]
  before_action :set_transaction, only: [:show, :upvote, :downvote]
  before_action :check_slack_connection, only: [:index]
  before_action :set_user, only: [:index, :show]
  after_action :update_slack_transaction, only: [:upvote, :downvote]

  def index
    @transaction = Transaction.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @transaction = @transaction.decorate
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @transaction = TransactionAdder.create(params[:transaction], current_user)

    if @transaction.save
      redirect_to root_path
    else
      flash[:error] = @transaction.errors.full_messages.to_sentence.capitalize
      @transaction.activity.name = @transaction.activity.name.split('for: ')[1]
      render :index
    end
  end

  def upvote
    @transaction.liked_by current_user

    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end

    if Balance.current.amount >= Goal.next.amount
      GoalReacher.check!
    end
  end

  def downvote
    @transaction.unliked_by current_user

    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  def kudo_guidelines
    kudos = params[:kudo_amount].to_i
    guidelines = Transaction.guidelines_between [(kudos - 10), 0].max, kudos + 10
    render json: guidelines
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def update_slack_transaction
    SlackService.instance.send_updated_transaction(@transaction)
  end

  def check_slack_connection
    if SLACK_IS_CONFIGURED && current_user.slack_id.blank?
      flash.now[:notice] = '<a href="/settings">Connect your ₭udo-o-Matic account to Slack</a>'.html_safe
    end
  end

  def query_variables
    @previous = Goal.previous.decorate
    @next = Goal.next.decorate
    @iterate_goals = Goal.goals
    @goals = Goal.all.order(cached_votes_up: :desc)
    @current_goals = Goal.all.where(balance: Balance.current).order('amount desc')

    @balance = Balance.current.decorate
    @achieved_goal = Goal.where(balance: Balance.current).where.not(achieved_on: nil).order('achieved_on desc')

    @sent_transactions_user = Transaction.where(sender: current_user).count
    @received_transactions_user = Transaction.where(receiver: current_user).count + received_transactions_company
    @all_transactions_user = @sent_transactions_user + @received_transactions_user

    period_week = Time.now.beginning_of_week..Time.now.end_of_week
    period_month = Time.now.beginning_of_month..Time.now.end_of_month

    transactions_week = transactions_period(period_week)
    transactions_month = transactions_period(period_month)

    @weekly_transactions = transactions_week.count
    @monthly_transactions = transactions_month.count
    @all_transactions = Transaction.count

    @weekly_kudos = transactions_week.sum(:amount) + likes_count_of_period(period_week)
    @monthly_kudos = transactions_month.sum(:amount) + likes_count_of_period(period_month)
    @all_kudos = Transaction.sum(:amount) + likes.count

    @markdown = Redcarpet::Markdown.new(MdEmoji::Render, no_intra_emphasis: true)

    case params['filter']
      when 'mine'
        @transactions = TransactionDecorator.decorate_collection(Transaction.all_for_user(current_user).page(params[:page]).per(20))
      when 'send'
        @transactions = TransactionDecorator.decorate_collection(Transaction.send_by_user(current_user).page(params[:page]).per(20))
      when 'received'
        @transactions = TransactionDecorator.decorate_collection(Transaction.received_by_user(current_user).page(params[:page]).per(20))
      else
        @transactions = TransactionDecorator.decorate_collection(Transaction.order('created_at desc').page(params[:page]).per(20))
    end
  end

  def transactions_period(period)
    Transaction.where(created_at: period)
  end

  def likes
    Transaction.joins("INNER JOIN votes on votes.votable_id = transactions.id and votable_type='Transaction'")
  end

  def likes_count_of_period(period)
    likes.where(created_at: period).count
  end

  def received_transactions_company
    receiver_company = User.where(name: ENV['COMPANY_USER'])
    Transaction.where(receiver: receiver_company).count
  end

  def set_user
    @user = current_user
  end
end
