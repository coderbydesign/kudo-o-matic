class DashboardController < ApplicationController
  layout 'dashboard'

  protect_from_forgery with: :exception

  def index
    @previous = Goal.previous.decorate
    @next     = Goal.next.decorate
    @iterate_goals  = Goal.goals
    @goals    = Goal.all.order(:cached_votes_up => :desc)
    @balance  = Balance.current.decorate
    @transactions = Transaction.order('created_at desc').page(params[:page]).per(20)
    @transaction = Transaction.new
  end


end
