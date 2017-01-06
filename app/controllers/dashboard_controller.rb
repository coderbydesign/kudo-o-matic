class DashboardController < ApplicationController
  layout 'dashboard'

  def index
    @previous = Goal.previous.decorate
    @next     = Goal.next.decorate
    @goals    = Goal.all.order(:cached_votes_up => :desc)
    @balance  = Balance.current.decorate
    @transactions = Transaction.order('created_at desc').page(params[:page]).per(20)
    @transaction = Transaction.new
  end
end
