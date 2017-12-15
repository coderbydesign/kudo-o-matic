Fcm::TransactionJob = Struct.new(:transaction) do
  def perform
    return if transaction.receiver.deactivated?

    registration_ids = transaction.receiver.fcm_tokens.collect(&:token).flatten.uniq
    return if registration_ids.blank?

    options = {
        notification: {
            title: '₭udos received!',
            body: "You just received #{transaction.amount} ₭ from #{transaction.sender.name}!",
            event: 'transaction'
        },
        priority: 'high'
    }

    FCM_SERVICE.send_notification(registration_ids, options)
  end

  def queue_name
    'fcm'
  end
end
