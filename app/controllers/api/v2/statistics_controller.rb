class Api::V2::StatisticsController < Api::V2::ApiController
  GRAPH_MONTHS_OF_DATA = 5

  def general
    period_week = Time.now.beginning_of_week..Time.now.end_of_week
    period_month = Time.now.beginning_of_month..Time.now.end_of_month

    transactions_week = transactions_period(period_week)
    transactions_month = transactions_period(period_month)

    @transactions_week = transactions_week.count
    @transactions_month = transactions_month.count
    @transactions_total = current_team.transactions.count

    @kudos_week = transactions_week.sum(:amount) + likes_count_of_period(period_week)
    @kudos_month = transactions_month.sum(:amount) + likes_count_of_period(period_month)
    @kudos_total = current_team.transactions.sum(:amount) + likes.count
  end

  def user
    @sent_transactions_user = current_team.transactions.where(sender: api_user).count
    @received_transactions_user = current_team.transactions.where(receiver: api_user).count + received_transactions_company
    @total_transactions_user = @sent_transactions_user + @received_transactions_user
  end

  def graph
    @graph = Hash.new

    (0..GRAPH_MONTHS_OF_DATA - 1).each {|i|
      month = i.month.ago.beginning_of_month
      period_month = month..i.month.ago.end_of_month
      transactions_month = transactions_period(period_month)

      data = {
          month: month.strftime('%B'),
          transactions: transactions_month.count,
          kudos: transactions_month.sum(:amount) + likes_count_of_period(period_month)
      }

      @graph.store(i, data)
    }
  end

  private

  def transactions_period(period)
    current_team.transactions.where(created_at: period, team_id: current_team.id)
  end

  def likes
    current_team.transactions.joins("INNER JOIN votes on votes.votable_id = transactions.id and votable_type='Transaction'")
  end

  def likes_count_of_period(period)
    likes.where(created_at: period).count
  end

  def received_transactions_company
    receiver_company = current_team.users.where(company_user: true)
    current_team.transactions.where(receiver: receiver_company).count
  end

end
