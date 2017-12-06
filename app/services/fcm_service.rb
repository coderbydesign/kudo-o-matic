class FcmService
  include Singleton

  def send_new_transaction(transaction)
    return unless fcm_service_configured
    return if transaction.receiver.deactivated?

    registration_ids = transaction.receiver.fcm_tokens.collect(&:token).flatten.uniq
    return if registration_ids.blank?

    options = {
        data: {
            title: '₭udos received!',
            body: "You just received #{transaction.amount} ₭ from #{transaction.sender.name}!"
        }
    }

    FCM_SERVICE.delay(queue: :fcm, priority: 1).send(registration_ids, options)
  end

  def send_goal_reached
    return unless fcm_service_configured

    registration_ids = FcmToken.joins(:user).where('deactivated_at IS NULL').collect(&:token).flatten.uniq

    return if registration_ids.blank?

    options = {
        data: {
            title: '₭udo goal reached!',
            body: "You and your colleagues just reached #{Goal.previous.name}!"
        }
    }

    FCM_SERVICE.delay(queue: :fcm, priority: 0).send(registration_ids, options)
  end

  def send_reminder
    return unless fcm_service_configured

    registration_ids = FcmToken.joins(:user).where('deactivated_at IS NULL').collect(&:token).flatten.uniq

    return if registration_ids.blank?

    options = {
        data: {
            title: '₭udo reminder!',
            body: "Don't forget to think back about this week, "\
                  'because there is definitely someone who deserves a compliment!'
        }
    }

    FCM_SERVICE.delay(queue: :fcm, priority: 2).send(registration_ids, options)
  end

  private

  def fcm_service_configured
    FCM_SERVICE.present?
  end
end