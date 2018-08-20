class Api::V2::UsersController < Api::V2::ApiController

  def sync
    render json: current_resource_owner.attributes, status: 200
  end

  def me
    render json: api_user.to_profile_json.target!, status: 200
  end

  def context
    {
        api_user: api_user,
        current_team: current_team
    }
  end
end
