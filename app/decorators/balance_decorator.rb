class BalanceDecorator < Draper::Decorator
  delegate_all

  def kudos
    h.number_to_kudos(object.amount)
  end

  def percentage
    current = (object.amount - Goal.previous.target_kudos).to_f
    target  = (Goal.next.target_kudos - Goal.previous.target_kudos).to_f

    (current / target * 100.0).round
  end
end
