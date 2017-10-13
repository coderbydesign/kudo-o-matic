class UsersController < ApplicationController
  def autocomplete_search
    @users = User.order(:name).where("lower(name) like ?", "#{params[:term]}%".downcase).where(deactivated_at: nil)
    render json: @users.map(&:name)
  end
end
