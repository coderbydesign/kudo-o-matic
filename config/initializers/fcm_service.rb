begin
  fcm_server_key = ENV['FCM_SERVER_KEY']
  FCM_SERVICE = fcm_server_key.present? ? FCM.new(fcm_server_key) : nil
end