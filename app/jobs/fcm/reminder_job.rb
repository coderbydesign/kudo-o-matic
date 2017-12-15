Fcm::ReminderJob = Struct.new(:nil) do
  def perform
    registration_ids = FcmToken.joins(:user).where('deactivated_at IS NULL').collect(&:token).flatten.uniq

    return if registration_ids.blank?

    options = {
        notification: {
            title: '₭udo reminder!',
            body: "Don't forget to think back about this week, "\
                  'because there is definitely someone who deserves a compliment!',
            event: 'reminder'
        },
        priority: 'high'
    }

    FCM_SERVICE.send(registration_ids, options)
  end

  def queue_name
    'fcm'
  end
end
