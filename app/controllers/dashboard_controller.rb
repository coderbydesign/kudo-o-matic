class DashboardController < ApplicationController
  layout 'dashboard'

  protect_from_forgery with: :exception

  def index
    @previous       = Goal.previous.decorate
    @next           = Goal.next.decorate
    @iterate_goals  = Goal.goals
    @goals          = Goal.all.order(:cached_votes_up => :desc)
    @balance        = Balance.current.decorate
    @transaction    = Transaction.new
    @achieved_goal  = Goal.where(balance: Balance.current).where.not(achieved_on: nil).order('achieved_on desc')

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
end
