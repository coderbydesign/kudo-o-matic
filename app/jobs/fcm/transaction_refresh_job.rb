Fcm::TransactionRefreshJob = Struct.new(:nil) do
  def perform
    registration_ids = FcmToken.joins(:user).where('deactivated_at IS NULL').collect(&:token).flatten.uniq
    return if registration_ids.blank?

    options = {
        data: {
            event: 'new_transaction'
        }
    }

    FCM_SERVICE.send_notification(registration_ids, options)
  end

  def queue_name
    'fcm'
  end
end
