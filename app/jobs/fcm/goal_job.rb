Fcm::GoalJob = Struct.new(:nil) do
  def perform
    registration_ids = FcmToken.joins(:user).where('deactivated_at IS NULL').collect(&:token).flatten.uniq

    return if registration_ids.blank?

    options = {
        notification: {
            title: '₭udo goal reached!',
            body: "You and your colleagues just reached #{Goal.previous.name}!",
            event: 'goal'
        },
        priority: 'high'
    }

    FCM_SERVICE.send(registration_ids, options)
  end

  def queue_name
    'fcm'
  end
end
