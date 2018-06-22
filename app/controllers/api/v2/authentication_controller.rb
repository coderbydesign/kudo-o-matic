class Api::V2::AuthenticationController < Api::V2::ApiController
  def store_fcm_token
    @fcm_token = params['fcmToken']
    api_user.fcm_tokens.find_or_create_by(token: @fcm_token)

    render 'api/v2/fcm/store', status: :created
  rescue => e
    handle_exceptions(e)
  end
end
