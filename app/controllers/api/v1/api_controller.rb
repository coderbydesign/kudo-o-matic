class Api::V1::ApiController < JSONAPI::ResourceController
  abstract

  before_action :authorize_request, :set_default_response_format

  private

  def authorize_request
    api_token = request.headers['Api-Token']
    api_token_unknown = !User.where(api_token: api_token).exists?

    if api_token.nil? || api_token_unknown
      error_object_overrides = {title: 'Unauthorized', detail: 'No valid API-token was provided.'}
      errors = Api::V1::UnauthorizedError.new(error_object_overrides).errors
      render_errors(errors)
    end
  end

  def set_default_response_format
    request.format = :json
  end
end
