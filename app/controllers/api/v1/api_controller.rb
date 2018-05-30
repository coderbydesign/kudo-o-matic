class Api::V1::ApiController < JSONAPI::ResourceController
  abstract

  before_action :authorize_request, :set_default_response_format

  def api_user
    User.where(api_token: api_token).first
  end

  private

  def api_token
    request.headers['Api-Token']
  end

  def team_id
    request.headers['Team']
  end

  def authorize_request
    if api_token.blank? || api_user.nil?
      error_object_overrides = {title: 'Unauthorized', detail: 'No valid API token was provided.'}
      errors = Api::V1::UnauthorizedError.new(error_object_overrides).errors
      render_errors(errors)
    end
  end

  def set_default_response_format
    request.format = :json
  end
end
