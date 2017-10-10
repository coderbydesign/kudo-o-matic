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
    begin
      GoogleIDToken::Validator.new.check(jwt_token, ENV["GOOGLE_CLIENT_ID_KUDO_O_MOBILE"])
    rescue GoogleIDToken::SignatureError => e
      error_object_overrides = {title: 'Invalid JWT Token', detail: "#{e.message}."}
      error = Api::V1::UnauthorizedError.new(error_object_overrides)
      raise error
    end
  end

  def api_token_request_params
    params.permit(:jwt_token, :uid, :provider, :name, :email, :avatar_url)
  end
end
