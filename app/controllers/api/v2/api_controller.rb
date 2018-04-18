class Api::V2::ApiController < JSONAPI::ResourceController
  abstract

  before_action :doorkeeper_authorize!, :set_default_response_format

  def api_user
    @current_user ||= User.find(doorkeeper_token[:resource_owner_id])
  end

  private

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: 'Not authorized' } }
  end

  def set_default_response_format
    request.format = :json
  end
end
