json.key_format! :dasherize

json.data do
  json.title 'Successfully stored FCM token'
  json.detail 'Firebase Cloud Messaging token was stored successfully.'
  json.fcm_token @fcm_token
end
