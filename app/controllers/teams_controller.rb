# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_user, only: [:index, :create]

  def index
    # If user has only one team, redirect to that team's dashboard
    if @user.teams.one?
      redirect_to dashboard_path(tenant: @user.teams.first.slug)
    end
    @teams = @user.teams
  end

  def new
    @team = Team.new(team_params)
  end

  def create
    @team = TeamAdder.create(params, current_user)

    if @team.persisted?
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
