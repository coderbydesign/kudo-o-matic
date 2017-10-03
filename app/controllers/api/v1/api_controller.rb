class Api::V1::ApiController < JSONAPI::ResourceController
  before_action :authorize_request, :set_default_response_format

  private

  def authorize_request
    api_token = request.headers['Api-Token']
    api_token_known = User.where(api_token: api_token).exists?

    unless !api_token.nil? && api_token_known
      render json: {error: 'Unauthorized'}, status: :unauthorized
    end
  end

  def set_default_response_format
    request.format = :json
  end
end
