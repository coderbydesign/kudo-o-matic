# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_user, only: [:index, :create]

  def index
    # If user has only one team, redirect to that team's dashboard
    if @user.teams.length == 1
      redirect_to dashboard_path(tenant: @user.teams[0].slug)
    end
    @teams = @user.teams
  end

  def new
    @team = Team.new(team_params)
  end

  def create
    @team = Team.create(
      name: params[:team][:name],
      slug: params[:team][:slug],
      general_info: params[:team][:general_info],
      logo: params[:team][:logo]
    )

    if @team.save
      @team.add_member(@user, true)
      TransactionAdder.create_for_new_team(@team, @user)
      flash[:success] = 'Team was successfully created!'
      redirect_to dashboard_path(tenant: @team.slug)
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
    params.permit(:name, :slug, :general_info, :logo)
  end
end
