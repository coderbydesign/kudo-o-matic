class Api::V1::AuthenticationController < ActionController::Base
  # before_action :add_allow_credentials_headers

  respond_to :json

  def retrieve_api_token
    if validate_jwt_token(params[:jwt_token])
      user = User.from_api_token_request(api_token_request_params)
      render json: {api_token: user.api_token}
    else
      render json: {error: 'Invalid ID token'}
    end
  end

  private

  def validate_jwt_token(jwt_token)
    validator = GoogleIDToken::Validator.new

    begin
      validator.check(jwt_token, ENV["KUDO_O_MOBILE_CLIENT_ID"])
      true
    rescue GoogleIDToken::SignatureError => e
      logger.error e.message
      false
    end
  end

  def api_token_request_params
    params.permit(:jwt_token, :uid, :provider, :name, :email, :avatar_url)
  end
end
