class Api::V2::UsersController < Api::V2::ApiController

  def sync
    render json: current_resource_owner.attributes, status: 200
  end

end
