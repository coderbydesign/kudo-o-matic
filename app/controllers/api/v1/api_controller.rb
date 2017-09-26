class Api::V1::ApiController < JSONAPI::ResourceController
  before_action :authenticate_request

  private

  def authenticate_request
    api_token = request.headers['Api-Token']
    api_token_known = User.where(api_token: api_token).exists?

    unless api_token_known
      render json: {error: 'Unauthorized'}
    end
  end
end
