# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_user, only: [:index, :create]
  before_action :check_team_admin_rights, only: [:manage]

  def new
    @team = Team.new(create_team_params)
  end

  def create
    @team = TeamAdder.create(params, current_user)

    if @team.persisted?
      redirect_to dashboard_path(team: @team.slug)
    else
      render :new
    end
  end

  def manage
    @team = current_team
    @team_invite_submissions = TeamInviteForm.new
  end

  def update
    @team = current_team
    @team_invite_submissions = TeamInviteForm.new
    if @team.update(team_params)
      flash[:success] = 'Successfully updated team!'
      redirect_to manage_path(@team.slug)
    else
      render :manage
    end
  end

  private

  def set_user
    @user = current_user
  end

  def check_restricted
    redirect_to root_url if current_user.restricted?
  end

  def create_team_params
    params.permit(:name)
  end

  def team_params
    params.permit(:name, :slug, :general_info, :logo)
  end
end
