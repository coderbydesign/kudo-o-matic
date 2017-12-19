Fcm::TransactionJob = Struct.new(:transaction) do
  def perform
    return if transaction.receiver.nil? || transaction.receiver.deactivated?

    registration_ids = transaction.receiver.fcm_tokens.collect(&:token).flatten.uniq
    return if registration_ids.blank?

    title = '₭udos received!'
    body = "You just received #{transaction.amount} ₭ from #{transaction.sender.name}!"
    event = 'transaction'

    options = {
        notification: {
            title: title,
            body: body,
            event: event,
            sound: 'default',
            badge: '1'
        },
        data: {
            title: title,
            body: body,
            event: event,
        },
        priority: 'high'
    }

    FCM_SERVICE.send_notification(registration_ids, options)
  end

  def queue_name
    'fcm'
  end
end
