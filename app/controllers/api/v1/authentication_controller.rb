class Api::V1::AuthenticationController < Api::V1::ApiController
  skip_before_action :authorize_request, only: [:obtain_api_token]

  def obtain_api_token
    validate_jwt_token(params[:jwt_token])

    @user = User.from_api_token_request(obtain_api_token_params)

    render 'api/v1/authentication/obtain_api_token', status: :created
  rescue => e
    handle_exceptions(e)
  end

  def store_fcm_token
    @fcm_token = params['fcm_token']
    api_user.fcm_tokens.find_or_create_by(token: @fcm_token)

    render 'api/v1/authentication/store_fcm_token', status: :created
  rescue => e
    handle_exceptions(e)
  end

  private

  def validate_jwt_token(jwt_token)
    validator = GoogleIDToken::Validator.new

    validator.check(jwt_token, ENV['GOOGLE_CLIENT_ID_KUDO_O_MOBILE_IOS'])
  rescue GoogleIDToken::ValidationError
    begin
      validator.check(jwt_token, ENV['GOOGLE_CLIENT_ID_KUDO_O_MOBILE_ANDROID'])
    rescue GoogleIDToken::ValidationError
      error_object_overrides = {title: 'Unauthorized', detail: 'No valid JSON Web Tokens token was provided.'}
      error = Api::V1::UnauthorizedError.new(error_object_overrides)
      raise error
    end
  end

  def obtain_api_token_params
    params.permit(:jwt_token, :uid, :provider, :name, :email, :avatar_url)
  end
end
