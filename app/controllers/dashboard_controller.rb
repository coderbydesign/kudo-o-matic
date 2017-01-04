class DashboardController < ApplicationController
  layout 'dashboard'

  def index
    @previous = Goal.previous.decorate
    @next     = Goal.next.decorate
    @goals    = Goal.all.order(:cached_votes_up => :desc)

    @balance  = Balance.current.decorate

    @transactions = Transaction.order('created_at desc').paginate(page: params[:page], per_page: 20)
    @transaction = Transaction.new


  end
end
