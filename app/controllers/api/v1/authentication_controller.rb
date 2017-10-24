class Api::V1::AuthenticationController < JSONAPI::ResourceController
  before_action :set_default_response_format

  def obtain_api_token
    begin
      validate_jwt_token(params[:jwt_token])

      @user = User.from_api_token_request(api_token_request_params)
      render 'api/v1/authentication/api_token', status: :ok
    rescue => e
      handle_exceptions(e)
    end
  end

  private

  def set_default_response_format
    request.format = :json
  end

  def validate_jwt_token(jwt_token)
    validator = GoogleIDToken::Validator.new

    begin
      validator.check(jwt_token, ENV['GOOGLE_CLIENT_ID_KUDO_O_MOBILE_IOS'])
    rescue GoogleIDToken::ValidationError
      begin
        validator.check(jwt_token, ENV['GOOGLE_CLIENT_ID_KUDO_O_MOBILE_ANDROID'])
      rescue GoogleIDToken::ValidationError
        error_object_overrides = {title: 'Invalid JWT Token', detail: 'No valid JWT-token was provided.'}
        error = Api::V1::UnauthorizedError.new(error_object_overrides)
        raise error
      end
    end
  end

  def api_token_request_params
    params.permit(:jwt_token, :uid, :provider, :name, :email, :avatar_url)
  end
end
