class DashboardController < ApplicationController
  layout 'dashboard'

  protect_from_forgery with: :exception

  def index
    @previous               = Goal.previous.decorate
    @next                   = Goal.next.decorate
    @iterate_goals          = Goal.goals
    @goals                  = Goal.all.order(:cached_votes_up => :desc)
    @current_goals          = Goal.all.where(balance: Balance.current).order('amount desc')
    @balance                = Balance.current.decorate
    @transaction            = Transaction.new
    @achieved_goal          = Goal.where(balance: Balance.current).where.not(achieved_on: nil).order('achieved_on desc')
    @number                 = ((Balance.current.amount.to_f - Goal.previous.amount.to_f) / (Goal.next.amount.to_f - Goal.previous.amount.to_f)) * 100
    @balance_percentage     = helper.number_to_percentage(@number, precision: 0)
    @send_transactions      = Transaction.where(balance: Balance.current).where(sender: current_user).count(:id)
    @received_transactions  = Transaction.where(balance: Balance.current).where(receiver: current_user).count(:id)
    @all_transactions       = @send_transactions + @received_transactions

    if params['filter'] == 'mine'
      @transactions = Transaction.all_for_user(current_user)
    elsif params['filter'] == 'send'
      @transactions = Transaction.send_by_user(current_user)
    elsif params['filter'] == 'received'
      @transactions = Transaction.received_by_user(current_user)
    else
      @transactions = Transaction.order('created_at desc').page(params[:page]).per(20)
    end
    respond_to do |format|Goal.where(balance: Balance.current).where.not(achieved_on: nil).order('achieved_on desc')
      format.html
      format.js
    end
  end

  private

  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end

end
