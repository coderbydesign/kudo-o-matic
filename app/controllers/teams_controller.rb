# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_user, only: [:create]

  def new
    @team = Team.new(team_params)
  end

  def create
    @team = Team.create(
      name: params[:team][:name],
      general_info: params[:team][:general_info],
      logo: params[:team][:logo]
    )

    if @team.save
      @team.add_member(@user, true)
      flash[:success] = 'Team was successfully created!'
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def set_user
    @user = current_user
  end

  def check_restricted
    redirect_to root_url if current_user.restricted?
  end

  def team_params
    params.permit(:name, :general_info, :logo)
  end
end
