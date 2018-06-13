# frozen_string_literal: true

class Api::V2::ApiController < JSONAPI::ResourceController
  abstract

  before_action :doorkeeper_authorize!, :set_default_response_format

  # Find the user that owns the access token
  def api_user
    current_resource_owner
  end

  def current_team
    @current_team ||= Team.find(request.headers['Team'])
  end

  private

  def doorkeeper_unauthorized_render_options(error: nil)
    error_object_overrides = { title: 'Unauthorized',
                               detail: 'No valid API token was provided.' }
    { json: {
      errors: Api::V1::UnauthorizedError.new(error_object_overrides).errors
    } }
  end

  def set_default_response_format
    request.format = :json
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
