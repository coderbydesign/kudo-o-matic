Fcm::GoalJob = Struct.new(:nil) do
  def perform
    registration_ids = FcmToken.joins(:user).where('deactivated_at IS NULL').collect(&:token).flatten.uniq

    return if registration_ids.blank?

    title = '₭udo goal reached!'
    body = "You and your colleagues just reached #{Goal.previous.name}!"
    event = 'goal'

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

    FCM_SERVICE.send(registration_ids, options)
  end

  def queue_name
    'fcm'
  end
end
