class TransactionDecorator < Draper::Decorator
  delegate_all

  def to_s
    return "No transaction available" if object.nil?

    [
      h.number_to_kudos(object.amount),
      "from",
      sender_name,
      "to",
      receiver_name,
      "for",
      activity_name
    ].join(" ")
  end

  def sender_name
    object.sender_name.upcase
  end

  def receiver_name
    object.receiver_name.upcase
  end

  def activity_name
    object.activity_name.upcase
  end

end
