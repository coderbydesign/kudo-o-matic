class UsersController < ApplicationController
  def autocomplete_search
    @users = User.order(:name).where("lower(name) like ?", "#{params[:term]}%".downcase)
    render json: @users.map(&:name)
  end
end
