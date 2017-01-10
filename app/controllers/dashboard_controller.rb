class DashboardController < ApplicationController
  layout 'dashboard'

  protect_from_forgery with: :exception
  before_action :first_time_visit, unless: -> { cookies[:first_visit] }

  def first_time_visit
    cookies.permanent[:first_visit] = 1
    @first_visit = true
  end

  def index
    @previous = Goal.previous.decorate
    @next     = Goal.next.decorate
    @goals    = Goal.all.order(:cached_votes_up => :desc)
    @balance  = Balance.current.decorate
    @transactions = Transaction.order('created_at desc').page(params[:page]).per(20)
    @transaction = Transaction.new
  end


end
