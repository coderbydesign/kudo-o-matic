class Api::V1::AuthenticationController < ActionController::Base
  before_action :set_default_response_format

  def obtain_api_token
    if validate_jwt_token(params[:jwt_token])
      @user = User.from_api_token_request(api_token_request_params)
      render 'api/v1/authentication/api_token', status: :ok
    else
      render 'api/v1/authentication/error', status: :unauthorized
    end
  end

  private

  def set_default_response_format
    request.format = :json
  end

  def validate_jwt_token(jwt_token)
    validator = GoogleIDToken::Validator.new

    begin
      validator.check(jwt_token, ENV["GOOGLE_CLIENT_ID_KUDO_O_MOBILE"])
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
