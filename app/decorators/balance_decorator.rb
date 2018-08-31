class BalanceDecorator < Draper::Decorator
  delegate_all

  def kudos
    h.number_to_kudos(object.amount)
  end

  def percentage
    current = (object.amount - Goal.previous.amount).to_f
    target  = (Goal.next.amount - Goal.previous.amount).to_f

    (current / target * 100.0).floor
  end
end
