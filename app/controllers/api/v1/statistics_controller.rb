class Api::V1::StatisticsController < Api::V1::ApiController
  GRAPH_MONTHS_OF_DATA = 5

  def general
    balance = Balance.current
    transactions = Transaction.where(balance: balance)

    period_week = Time.now.beginning_of_week(start_day = :monday)..Time.now.end_of_week
    period_month = Time.now.beginning_of_month..Time.now.end_of_month

    @transactions_week = transactions.where(created_at: period_week).count
    @transactions_month = transactions.where(created_at: period_month).count
    @transactions_total = Transaction.count

    likes = transactions.joins("INNER JOIN votes on votes.votable_id = transactions.id and votable_type='Transaction'")
    likes_week = likes.where(created_at: period_week).count
    likes_month = likes.where(created_at: period_month).count

    @kudos_week = transactions.where(created_at: period_week).sum(:amount) + likes_week
    @kudos_month = transactions.where(created_at: period_month).sum(:amount) + likes_month
    @kudos_total = balance.amount
  end

  def user
    @sent_transactions_user = Transaction.where(sender: api_user).count
    @received_transactions_user = Transaction.where(receiver: api_user).count

    receiver_company = User.where(name: ENV['COMPANY_USER'])
    received_transactions_company = Transaction.where(receiver: receiver_company).count
    @total_transactions_user = @sent_transactions_user + @received_transactions_user + received_transactions_company
  end

  def graph
    balance = Balance.current
    transactions = Transaction.where(balance: balance)

    @graph = Hash.new

    (0..GRAPH_MONTHS_OF_DATA - 1).each {|i|
      month = i.month.ago.beginning_of_month
      period_month = month..i.month.ago.end_of_month

      likes = transactions.joins("INNER JOIN votes on votes.votable_id = transactions.id and votable_type='Transaction'")
      likes_month = likes.where(created_at: period_month).count

      data = {
          transactions: transactions.where(created_at: period_month).count,
          kudos: transactions.where(created_at: period_month).sum(:amount) + likes_month
      }

      @graph.store(month.strftime('%B'), data)
    }
  end
end
