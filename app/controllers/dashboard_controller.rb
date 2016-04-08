class DashboardController < ApplicationController
  def index
    @previous = Goal.previous.decorate
    @next     = Goal.next.decorate

    @balance  = Balance.current.decorate

    @last_transaction = TransactionDecorator.decorate(@balance.last_transaction)
  end
end
